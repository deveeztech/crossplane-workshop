# Set the host's OS. Only linux and darwin supported for now
HOSTOS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ifeq ($(filter darwin linux,$(HOSTOS)),)
$(error build only supported on linux and darwin host currently)
endif

# Set the host's arch.
HOSTARCH := $(shell uname -m)

# If SAFEHOSTARCH and TARGETARCH have not been defined yet, use HOST
ifeq ($(origin SAFEHOSTARCH),undefined)
SAFEHOSTARCH := $(HOSTARCH)
endif
ifeq ($(origin TARGETARCH), undefined)
TARGETARCH := $(HOSTARCH)
endif

# Automatically translate x86_64 to amd64
ifeq ($(HOSTARCH),x86_64)
SAFEHOSTARCH := amd64
TARGETARCH := amd64
endif

# Automatically translate aarch64 to arm64
ifeq ($(HOSTARCH),aarch64)
SAFEHOSTARCH := arm64
TARGETARCH := arm64
endif

ifeq ($(filter amd64 arm64 ppc64le ,$(SAFEHOSTARCH)),)
$(error build only supported on amd64, arm64 and ppc64le host currently)
endif

# Standardize Host Platform variables
HOST_PLATFORM := $(HOSTOS)_$(HOSTARCH)
SAFEHOSTPLATFORM := $(HOSTOS)-$(SAFEHOSTARCH)
SAFEHOST_PLATFORM := $(HOSTOS)_$(SAFEHOSTARCH)
TARGET_PLATFORM := $(HOSTOS)_$(TARGETARCH)

# include the common make file
SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

# the root directory of this repo
ifeq ($(origin ROOT_DIR),undefined)
ROOT_DIR := $(abspath $(shell cd $(SELF_DIR)/../.. && pwd -P))
endif

# the output directory which holds final build produced artifacts
ifeq ($(origin OUTPUT_DIR),undefined)
OUTPUT_DIR := $(ROOT_DIR)/_output
endif
# a directory that holds tools and other items that are safe to cache
# across build invocations. removing this directory will trigger a
# re-download and waste time. Its safe to cache this directory on CI systems
ifeq ($(origin CACHE_DIR), undefined)
CACHE_DIR := $(ROOT_DIR)/.cache
endif

TOOLS_DIR := $(CACHE_DIR)/tools
TOOLS_HOST_DIR := $(TOOLS_DIR)/$(HOST_PLATFORM)


# ====================================================================================
# Logger

TIME_LONG	= `date +%Y-%m-%d' '%H:%M:%S`
TIME_SHORT	= `date +%H:%M:%S`
TIME		= $(TIME_SHORT)

INFO	= echo ${TIME} ${BLUE}[ .. ]${CNone}
WARN	= echo ${TIME} ${YELLOW}[WARN]${CNone}
ERR		= echo ${TIME} ${RED}[FAIL]${CNone}
OK		= echo ${TIME} ${GREEN}[ OK ]${CNone}
FAIL	= (echo ${TIME} ${RED}[FAIL]${CNone} && false)

-include k8s_tools.mk

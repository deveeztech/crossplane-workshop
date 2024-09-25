PROJECT_NAME := crossplane-workshop
CROSSPLANE_VERSION := v1.16.1
KOMOPLANE_VERSION := v0.1.5

-include build/makelib/common.mk
-include build/makelib/k8s_tools.mk

## Directives
.PHONY: help dev dev-clean
.DEFAULT_GOAL := help

help: ## help: Shows this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%s\n", $$2}'

dev: $(KIND) $(KUBECTL) $(HELM3) ## dev: Prepare a development environment
	@mkdir -p $(TOOLS_HOST_DIR)
	@$(INFO) Creating kind cluster
	@$(KIND) create cluster --name=$(PROJECT_NAME)-local --image=kindest/node:v1.29.8
	@$(KUBECTL) cluster-info --context kind-$(PROJECT_NAME)-local
	@$(INFO) Ensuring latest Crossplane Chart version
	@$(HELM3) repo add crossplane-stable https://charts.crossplane.io/stable
	@$(HELM3) repo update crossplane-stable
	@$(INFO) Installing Crossplane on Cluster
	@$(KUBECTL) create namespace crossplane-system
	@$(HELM3) install crossplane --namespace crossplane-system crossplane-stable/crossplane --version=$(CROSSPLANE_VERSION)
	@$(INFO) Installing Crossplane CRDs
	@$(KUBECTL) apply --server-side -k https://github.com/crossplane/crossplane//cluster?ref=$(CROSSPLANE_VERSION)
	@$(INFO) Installing Komoplane
	@$(HELM3) repo add komodorio https://helm-charts.komodor.io
	@$(KUBECTL) create namespace komodorio
	@$(HELM3) repo update komodorio
	@$(HELM3) install komoplane --namespace komodorio komodorio/komoplane --version=$(KOMOPLANE_VERSION)
	@$(INFO) DONE!

install-spotify-provider: $(KUBECTL) ## install-spotify-provider: Install Spotify Provider
	@$(INFO) Installing Spotify Provider
	@$(KUBECTL) apply -f 2-providers/spotify/provider/provider.yaml
	@$(INFO) Awaiting until provider is ready
	@sleep 30
	@$(KUBECTL) apply -f 2-providers/spotify/provider/config.yaml

install-compositions: $(KUBECTL) ## install-compositions: Install HTTP Provider & Workshop compositions
	@$(INFO) Installing HTTP Provider
	@$(KUBECTL) apply -f 3-compositions/provider-http/provider.yaml
	@$(INFO) Awaiting until provider is ready
	@sleep 30
	@$(KUBECTL) apply -f 3-compositions/provider-http/config.yaml
	@$(INFO) Instilling Workshop compositions
	@$(KUBECTL) apply -f 3-compositions/definitions

install-functions: $(KUBECTL) ## install-functions: Install Functions and compositions based on functions
	@$(INFO) Installing Fucntions
	@$(KUBECTL) apply -f 4-functions/functions.yaml
	@$(INFO) Instilling Function Compositions
	@$(KUBECTL) apply -f 4-functions/composition.yaml

uninstall-spotify-provider: $(KUBECTL) ## uninstall-compositions: Uninstall HTTP Provider & Workshop compositions (resources will be deleted before uninstalling)
	@$(INFO) Uninstalling Spotify Provider
	@$(KUBECTL) delete -f 2-providers/spotify/provider
	
uninstall-compositions: $(KUBECTL) ## uninstall-compositions: Uninstall Compositions (resources will be deleted before uninstalling)
	@$(INFO) Uninstilling Compositions
	@$(KUBECTL) apply -f 3-compositions/definitions
	@$(INFO) Uninstalling Provider HTTP
	@$(KUBECTL) delete -f 3-compositions/provider-http

uninstall-functions: $(KUBECTL) ## uninstall-functions: Uninstall Functions and compositions based on functions (resources will be deleted before uninstalling)
	@$(INFO) Uninstilling Function Compositions
	@$(KUBECTL) apply -f 4-functions/composition.yaml
	@$(INFO) Uninstalling Fucntions
	@$(KUBECTL) delete -f 4-functions/functions.yaml

dev-clean: $(KIND) $(KUBECTL) ## dev-clean: Clean up development environment
	@$(INFO) Deleting kind cluster
	@$(KIND) delete cluster --name=$(PROJECT_NAME)-local

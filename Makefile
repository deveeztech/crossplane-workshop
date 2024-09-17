PROJECT_NAME := provider-spotify
CROSSPLANE_VERSION := v1.16.1

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
	@$(KIND) create cluster --name=$(PROJECT_NAME)-dev --image=kindest/node:v1.29.8
	@$(KUBECTL) cluster-info --context kind-$(PROJECT_NAME)-dev
	@$(INFO) Ensuring latest Crossplane Chart version
	@$(HELM3) repo add crossplane-stable https://charts.crossplane.io/stable
	@$(HELM3) repo update crossplane-stable
	@$(INFO) Installing Crossplane on Cluster
	@$(KUBECTL) create namespace crossplane-system
	@$(HELM3) install crossplane --namespace crossplane-system crossplane-stable/crossplane --version=$(CROSSPLANE_VERSION)
	@$(INFO) Installing Crossplane CRDs
	@$(KUBECTL) apply --server-side -k https://github.com/crossplane/crossplane//cluster?ref=$(CROSSPLANE_VERSION)
	@$(INFO) DONE!

install-spotify-provider: $(HELM3) $(KUBECTL) ## install-spotify-provider: Install Spotify Provider and auth-proxy
	@$(INFO) Installing Spotify Auth Proxy
	@$(KUBECTL) apply -f 1-provider/spotify/auth-proxy.yaml

uninstall-spotify-provider: $(HELM3) $(KUBECTL) ## uninstall-spotify-provider: Uninstall Spotify Provider and auth-proxy
	@$(INFO) Uninstalling Spotify Auth Proxy
	@$(KUBECTL) delete -f 1-provider/spotify/auth-proxy.yaml

	
dev-clean: $(KIND) $(KUBECTL) ## dev-clean: Clean up development environment
	@$(INFO) Deleting kind cluster
	@$(KIND) delete cluster --name=$(PROJECT_NAME)-dev

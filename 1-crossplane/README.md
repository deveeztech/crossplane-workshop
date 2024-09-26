# Crossplane in action
In this step we will understand the basics of crossplane, install it and interact with the UI of komoplane


## What's Crossplane?
[Crossplane](https://crossplane.io) is an open source Kubernetes add-on that enables platform teams to assemble infrastructure from multiple vendors, and expose higher level self-service APIs for application teams to consume.


### Core Control plane
The base Crossplane installation consists of two pods, the [crossplane pod](https://docs.crossplane.io/v1.17/concepts/pods/#crossplane-pod) and the [crossplane-rbac-manager pod](https://docs.crossplane.io/v1.17/concepts/pods/#crossplane-pod). Both pods install in the crossplane-system namespace by default.
![Crossplane Internal Stack](/docs/crossplane-internal-stack.webp "Crossplane Internal Stack")


## How to install it
For the workshop we need a kubernetes cluster where install crossplane and its CRDS. We have prepared a Makefile:
~~~bash
make dev
~~~

To check that crossplane is running correctly you could execute the following command:
~~~bash
kubectl get deployments -n crossplane-system
~~~

and if any of your deployments are not in available state, please raise your hand for help :)

### What does `make dev` do?

- Install kubectl, helm and kind if they are not present in your machine
- Create a kind cluster
- Create crossplane-system and komodorio namespaces
- Install crossplane
- Install komoplane

## UI
To help understand the objects created and managed by crossplane, we are going to use [komoplane](https://github.com/komodorio/komoplane). The goal is to help Crossplane users to understand the structure of their control plane resources and speed up troubleshooting.

Application can be accessed by:
~~~bash
kubectl port-forward -n komodorio svc/komoplane 8090:8090
~~~

Then you can visit http://127.0.0.1:8090 to use the UI
![Komoplane Dashboard](/docs/komoplane-dashboard.png "Komoplane Dashboard")

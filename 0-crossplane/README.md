# Crossplane in action

## What's Crossplane?
"[Crossplane](https://crossplane.io) is an open source Kubernetes add-on that enables platform teams to assemble infrastructure from multiple vendors, and expose higher level self-service APIs for application teams to consume."

### Core Control plane
The base Crossplane installation consists of two pods, the [crossplane pod](https://docs.crossplane.io/v1.17/concepts/pods/#crossplane-pod) and the [crossplane-rbac-manager pod](https://docs.crossplane.io/v1.17/concepts/pods/#crossplane-pod). Both pods install in the crossplane-system namespace by default.


## How to install it
For the workshop we need a kubernetes cluster where install crossplane and its CRDS. We have prepared a Makefile:
~~~bash
make -C ../ dev
~~~

To check that crossplane is running correctly you could execute the following command:
~~~bash
kubectl get deployments -n crossplane-system
~~~

and if any of your deployments are not in available state, please raise your hand for help :)
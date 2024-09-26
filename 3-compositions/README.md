# Compositions in action
In this step we will create our first composition, XRD and request a claim to create our first stack!

## What's Composition?
[Compositions](https://docs.crossplane.io/latest/concepts/compositions/) are a template for creating multiple managed resources as a single object. A Composition composes individual managed resources together into a larger, reusable, solution

## How to install it
~~~bash
make install-compositions
~~~

To check that the composition is available and the provider is running correctly you could execute the following commands:
~~~bash
kubectl get providers provider-http
kubectl get compositions workshop-album
~~~

If some resource is not installed or healthy, please raise your hand for help :)

## How does a Composition works?
![Composition how it works](/docs/composition-how-it-works.svg "Composition how it works")

### Claim
A [claim](https://docs.crossplane.io/latest/concepts/claims/) represents a set of managed resources as a single Kubernetes object, inside a namespace. Users create claims when they access the custom API, defined in the XRD.

### XRD
Composite Resource Definitions or [XRDs](https://docs.crossplane.io/latest/concepts/composite-resource-definitions/) define the schema for a custom API. Users create composite resources (XRs) and Claims (XCs) using the API schema defined by an XRD.

In other words: Is the contract that the final user has to satisfy to create a claim

## Create a claim
In the [xrd.yaml](/3-compositions/definitions/xrd.yaml) installed in the previous command we define the openAPIV3Schema that the claim has to accomplish. Note that the XRD creates a composite based on the selectors of the claim and the section defined in:
~~~yaml
spec:
  group: workshop.deveez.com
  names:
    kind: XAlbum
    plural: xalbums
~~~

In this case ist the composition defined in [composition.yaml](/3-compositions/definitions/composition.yaml) that create a playlist and HTTP post with the parameters given in the claim. Please fill the spec with the parameters needed to create the claim :)
~~~yaml
apiVersion: workshop.deveez.com/v1alpha1
kind: Album
metadata:
  name: my-first-claim
  namespace: default
spec:
  compositionSelector:
    matchLabels:
      selectors.deveez.com/type: resources
      selectors.deveez.com/component: album
      selectors.deveez.com/team: workshop
      selectors.deveez.com/channel: alpha
  # fill your params here :)
~~~

### Check it internally
To view the result in the cluster, you can go to the _Claims_ section in Komoplane or execute:
~~~bash
kubectl get album my-first-claim -n default
~~~

### Check it externally
- [deveez playlists](https://open.spotify.com/user/31lxtsb5grogjpnytlkdzz63qniy)

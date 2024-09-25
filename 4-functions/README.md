# Functions in action
In this step we will see how compositions based in functions works and we will create a new claim with this type of compositions

## What's a Function (pipeline) Composition?
Crossplane calls a Function to determine what resources it should create when you create a composite resource. The Function also tells Crossplane what to do with these resources when you update or delete a composite resource.

When Crossplane calls a Function it sends it the current state of the composite resource. It also sends it the current state of any managed resources the composite resource owns.

Crossplane knows what Function to call when a composite resource changes by looking at the Composition the composite resource uses.

## How to install it
~~~bash
make install-functions
~~~

To check that fnuctions is running correctly and the composition is created you could execute the following commands:
~~~bash
kubectl get functions
kubectl get compositions workshop-album-pipeline
~~~

If some resource is not installed or healthy, please raise your hand for help :)

## How does a Composition based on functions works?
Each composition function is actually a gRPC server. gRPC is a high performance, open source remote procedure call (RPC) framework. When you install a function Crossplane deploys the function as a gRPC server. Crossplane encrypts and authenticates all gRPC communication.

![Functions Compositions](/docs/functions-composition.png "Functions Compositions")

When Crossplane calls a function the first time it includes four important things in the RunFunctionRequest.

1. The observed state of the composite resource, and any composed resources.
2. The desired state of the composite resource, and any composed resources.
3. The function’s input.
4. The function pipeline’s context.

A function’s main job is to update the desired state and return it to Crossplane

## Create a claim
Now we can set dynamicly the resources created based in the parameters recived, so we can test with the following claim what is the behaviour :)
~~~yaml
apiVersion: workshop.deveez.com/v1alpha1
kind: Album
metadata:
  name: my-second-claim
spec:
  compositionSelector:
    matchLabels:
      selectors.deveez.com/type: pipeline
      selectors.deveez.com/component: album
      selectors.deveez.com/team: workshop
      selectors.deveez.com/channel: alpha
  # add your params here :)
~~~

### Check it internally
To view the result in the cluster, you can go to the _Claims_ section in Komoplane or execute:
~~~bash
kubectl get album my-second-claim -n default
~~~

### Check it externally
- [deveez playlists](https://open.spotify.com/user/31lxtsb5grogjpnytlkdzz63qniy)


### Migrating existing `Resources` compositions
Crossplane provides a way to migrate old resources compositions (those that used Patch & Transform) to Pipeline mode compositions (aka Functions).

You can test this migration yourself and compare with the one we used before by doing:
```bash
.cache/crossplane beta convert pipeline-composition 3-compositions/definitions/composition.yaml > 4/functions/composition_migrated.yaml
```

### Debugging pipeline compositions
When creating compositions, things can get really long and complex easily. In order to improve developer experience, the crossplane CLI also allows you to view a rendered version of the composition without having to deploy it and run it.

The CLI accepts various parameters that provides the function request with all necessary data:
```bash
# crossplane beta render CLAIM_OR_COMPOSITE WITH_COMPOSITION AND_FUNCTIONS --extra-args
#
# IMPORTANT: bear in mind that if you use some of the composite annotations (such as composite name, or anything else) you have to use the composite to render.
#
# ARGS:
# -o, --observed-resources: useful to provide a list of already "created" resources (VERY useful if needing data from already created objects in your composition)
# -e, --extra-resources: all other resources that are not observed by this composition (as environment configs)
.cache/crossplane beta render 4-functions/claim.yaml 4-functions/composition.yaml 4-functions/functions.yaml

# as you can see in the results, something is missing :)
# let's include the "ready" Playlist, so we can see what the Request would be
.cache/crossplane beta render 4-functions/claim.yaml 4-functions/composition.yaml 4-functions/functions.yaml -o 4-functions/observed.yaml
```

# Providers in action
In this step we will install a provider, understand how a provider works and create our first resource (a playlist) in spotify

## What's Provider?
A [provider](https://docs.crossplane.io/latest/concepts/providers/) in Crossplane is an extension or plugin that allows Crossplane to manage external resources across third parties. Providers enable Crossplane to interact with APIs of different cloud, service and on-prem providers, making it possible to provision and manage infrastructure resources from platforms like AWS, Azure, Google Cloud, and others.


## How to install it
~~~bash
make install-spotify-provider
~~~

To check that provider is running correctly you could execute the following command:
~~~bash
kubectl get providers provider-spotify
~~~

and if the provider has not installed or healthy, please raise your hand for help :)

## How does a Provider work?
- **Install**: To use a provider, you first install it into your Crossplane environment (e.g., `crossplane-provider-aws`, `crossplane-provider-azure`).
- **Configure**: After installation, you configure the provider with the necessary credentials (such as API keys or secrets) to authenticate with the cloud service.
- **Provision**: Once set up, you can create custom resources representing cloud infrastructure. Crossplane will use the provider to communicate with the cloud API and ensure the resources are provisioned and maintained.

### Resource Reconcile Loop
![Provider Reconcile Loop](/docs/provider-reconcile-loop.png "Provider Reconcile Loop")


## Create a resource
As we saw the provider defines the resources (CRDs) that will manage. In the case of spotify-provider it defines only a [Playlist](https://github.com/crossplane-contrib/provider-spotify/tree/main/apis)

To create a playlist, you can create a yaml with the following content, and edit the `forProvider` data as you like
~~~yaml
apiVersion: playlist.spotify.crossplane.io/v1alpha1
kind: Playlist
metadata:
  name: my-first-playlist
spec:
  forProvider:
    name: "My First Playlist"
    description: "created and managed by crossplane-provider-spotify"
    public: true
    tracks:
      - "6WatFBLVB0x077xWeoVc2k"
  providerConfigRef:
    name: deveez-dev
~~~

Note that the `providerConfigRef` should match with the previous **ProviderConfig** created with the right credentials. 

### Check it internally
To view the result in the cluster, you can go to the _Managed Resources_ section in Komoplane or execute:
~~~bash
kubectl get playlists
~~~

### Check it externally
To view the result, please visit the playlists of [deveez](https://open.spotify.com/user/31lxtsb5grogjpnytlkdzz63qniy)

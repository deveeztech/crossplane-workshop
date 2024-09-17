# Crossplane in action

## What's Crossplane?
"[Crossplane](https://crossplane.io) is an open source Kubernetes add-on that enables platform teams to assemble infrastructure from multiple vendors, and expose higher level self-service APIs for application teams to consume."

## What we'll build
We are going to cover the basics of Crossplane, by creating some Spotify Playlists that will be fully managed declaratively with Compositions :)

## Requirements
### 1. Local dev environment
- [ ] your favourite IDE
- [ ] docker / orbstack 
- [ ] [KinD](https://kind.sigs.k8s.io/) / [minikube](https://minikube.sigs.k8s.io/docs/) (we'll be using KinD for this workshop)
- [ ] 

### 2. Software requirements
- [ ] [Crossplane](https://docs.crossplane.io/latest/software/install/)
- [ ] [Spotify Provider](https://github.com/crossplane-contrib/provider-spotify)
- [ ] [Spotify Developer Account](https://developer.spotify.com/dashboard)
- [ ] [Spotify Auth Proxy](https://github.com/conradludgate/terraform-provider-spotify/tree/main/spotify_auth_proxy) - However, we've already deployed one in XXXX

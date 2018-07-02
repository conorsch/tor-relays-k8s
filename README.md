---
# Intro
Prototype project for running Tor relays on Kubernetes.

The motivation was to evaluate whether Kubernetes is an appropriate solution for other projects.

# Overview

Explore the directory tree:


```
 $ tree
 .
 ├── docker
 │   ├── Dockerfile
 │   ├── README.md
 │   ├── run.sh
 │   └── torrc.middle
 ├── k8s
 │   ├── pods
 │   │   ├── tor-relay-1.yml
 │   │   └── tor-relay-2.yml
 │   └── services
 │       ├── tor-relay-lb-1.yml
 │       └── tor-relay-lb-2.yml
 ├── Makefile
 ├── README.md
 └── scripts
     └── config-maps
```

Within `docker/` are the files used to build the container image. Can be ignored for
the purposes of the demo.

Within `k8s/` are the Kubernetes YAML config files, for Pods and Services. Notably there are no
files for ConfigMaps; those are handled via a script.

Within `scripts/` is the ConfigMap bootstrapping script. We cannot create the ConfigMaps via
YAML files due to an ordering problem: we need the external IPs for the LoadBalancer services
to be provisioned in order to include them in the ConfigMap, whereby they're available
to the container images.

# Quickstart
Make sure you've activated a GKE instance. You'll need the `kubectl` binary locally.

```
make k8s
```

That will pull the container image and spin up four (4) relays, spread over two (2) pods,
with two (2) loadbalancer services for ingress. When you're all finished:

```
make destroy
```

will clean up. No need to run `make container` unless you override the remote endpoints,
both in the Makefile and in the pod configs.

# Details
The reason we need the load balancers is because tor needs to know its 
external-facing IP address. If spun up instead without LBs, the tor containers
will try to guess the IP address, and get it wrong. We can't reuse a single LB,
because tor imposes a maximum of two (2) tor relays per IP address.

The containers will wait for the creation of the ConfigMaps in order to exec tor.
The ConfigMaps expose the env var `RELAY_ADDRESS`, populated from the LB service
configs, to the containers.

# Caveats
The config dependencies introduces a run order requirement: the services *must*
be created before the configmaps, which must be created in order for the containers
to run successfully. The polling logic in `scripts/config-maps` handles the wait
appropriately.

If you run this, you may want to change the tor relay names, in order to find them
easily on [Tor Atlas](https://atlas.torproject.org/). Otherwise, you'll need to
search by relay fingerprint to make sure you're viewing the correct relay.

# License
MIT

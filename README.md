# oc-mirror-container
For more information on oc-mirror, visit their [repo], its still under very active devolopment
Minimal container to run co-mirror where dependencies are an issue/disconnected. Based on Fedora 35

Tested on rhel 8.5/Fedora 34 not subscribed, glibc version not availible. requires 2.32+ only 2.28 availilbe on system

The workdir/user for the container is set to root, just to try and simply the volume mounts

# pre-reqs

- System with podman
- [Valid Pull Secret]

## Pull from quay.io

```podman pull quay.io/mriensch/oc-mirror-container```

## Build

## Clone this repo
```git clone https://github.com/mriensch/oc-mirror-container.git```

### Build Container
```podman build -t oc-mirror . ```

### Build tar
- I put my imageset-config.yml in ./archive to simply the volume mounts
- Need to have you're pull secret configured and mounted to /root/.docker/config.json
```podman run --rm -v ~/.docker/config.json:/root/.docker/config.json:z -v ./archive:/root/archive:z ocm:latest --config archive/imageset-config.yml file://archive/```

- I renamed my generated tar from mirror_seq1_000000.tar to mirror.tar

## Export Container
```podman save localhost/oc-mirror:latest > oc-mirror.tar```

## Import

### Container
- not going to cover how to move data to another machine
- import container
```podman load < oc-mirror.tar```

### Mirrored Content

- run the oc-mirror import for you generated tar

``` podman run --rm -v ~/.docker/config.json:/root/.docker/config.json:z -v /path/to/mirror.tar:/root/mirror.tar:z localhost/oc-mirror --from mirror.tar docker://<registry>:<registry.port>```

### Everything else
Refrence the oc-mirror [repo]

[Valid Pull Secret]:https://cloud.redhat.com/openshift/install/metal/user-provisioned
[repo]:https://github.com/openshift/oc-mirror
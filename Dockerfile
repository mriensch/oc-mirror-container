# docker build -f Dockerfile -t local/go-toolset .
# docker run -it --rm --privileged -v ${PWD}:/build:z local/go-toolset
#################################################################################
# Builder Image
FROM registry.fedoraproject.org/fedora:35 as builder

#################################################################################
# DNF Package Install List
ARG DNF_LIST="\
  go \
  gcc \
  make \
  git \
"

#################################################################################
# Make the Binary
RUN set -ex \
     && dnf install -y --nodocs --setopt=install_weak_deps=false ${DNF_LIST}    \
     && dnf clean all -y                                                        \
     && cd /root                                                                \
     && git clone https://github.com/openshift/oc-mirror.git                    \
     && cd oc-mirror                                                            \
     && make build 

#################################################################################
# Create image from /root/oc-mirror
FROM registry.fedoraproject.org/fedora:35
COPY --from=builder /root/oc-mirror/bin /root/oc-mirror/bin

WORKDIR /root
ENTRYPOINT ["oc-mirror"]

ENV PATH="/root/oc-mirror/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

LABEL \
  name="go-toolset"                                                             \
  license=GPLv3                                                                 \
  distribution-scope="public"                                                   \
  io.openshift.tags="go-toolset"                                                \
  summary="oc-mirror compiler image"                                            \
  io.k8s.display-name="go-toolset"                                              \
  build_date="`date +'%Y%m%d%H%M%S'`"                                           \
  project="https://github.com/openshift/oc-mirror"                              \
  description="oc-mirror is an OpenShift Client (oc) plugin that manages OpenShift release, operator catalog, helm charts, and associated container images. This image is designed to build the binary." \
  io.k8s.description="oc-mirror is an OpenShift Client (oc) plugin that manages OpenShift release, operator catalog, helm charts, and associated container images. This image is designed to build the binary."

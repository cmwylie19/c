ARG BASE_REGISTRY=registry1.dso.mil
ARG BASE_IMAGE=ironbank/redhat/ubi/ubi8
ARG BASE_TAG=8.6

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

RUN dnf update -y --nodocs && \
    dnf clean all && \
    rm -rf /var/cache/dnf

HEALTHCHECK NONE

USER nobody

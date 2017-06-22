FROM ubuntu:latest
MAINTAINER Michael Venezia <mvenezia@gmail.com>

ENV HELM_RELEASE=v2.5.0
ENV APP_REGISTRY_PLUGIN_RELEASE=v0.4.1

RUN mkdir -p ~/.helm/plugins

RUN apt-get update && apt-get install -y curl openssl && \
    curl -k -L https://storage.googleapis.com/kubernetes-helm/helm-${HELM_RELEASE}-linux-amd64.tar.gz | tar -zxv linux-amd64/helm && \
    mv linux-amd64/helm /usr/bin/ && rm -rf linux-amd64 && \
    cd ~/.helm/plugins && \
    curl -k -L https://github.com/app-registry/appr-helm-plugin/releases/download/${APP_REGISTRY_PLUGIN_RELEASE}/registry-helm-plugin.tar.gz | tar -zxv && \
    helm registry list quay.io


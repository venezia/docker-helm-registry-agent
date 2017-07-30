FROM ubuntu:latest
MAINTAINER Michael Venezia <mvenezia@gmail.com>

ENV HELM_HOME=/etc/helm
ENV HELM_PLUGIN=/etc/helm/plugins
ENV HELM_RELEASE=v2.5.1
ENV APP_REGISTRY_PLUGIN_RELEASE=v0.5.1
ENV APP_REGISTRY_URL=https://github.com/app-registry/appr-helm-plugin/releases/download/${APP_REGISTRY_PLUGIN_RELEASE}/registry-helm-plugin.tar.gz

RUN mkdir -p /etc/helm/plugins/appr && ln -s /etc/helm ~/.helm

RUN apt-get update && apt-get install -y wget openssl git gettext-base curl
RUN wget https://storage.googleapis.com/kubernetes-helm/helm-${HELM_RELEASE}-linux-amd64.tar.gz -O - | tar -zxv linux-amd64/helm && \
    mv linux-amd64/helm /usr/bin/ && rm -rf linux-amd64
WORKDIR /etc/helm/plugins
RUN wget ${APP_REGISTRY_URL} -O - | tar -zxv
WORKDIR /
RUN helm plugin list && \
    helm registry list quay.io

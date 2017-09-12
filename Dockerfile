FROM alpine:latest
MAINTAINER Michael Venezia <mvenezia@gmail.com>

ENV HELM_HOME=/etc/helm
ENV HELM_PLUGIN=/etc/helm/plugins
ENV HELM_RELEASE=v2.6.1
ENV APP_REGISTRY_PLUGIN_RELEASE=v0.7.0
ENV APP_REGISTRY_URL=https://github.com/app-registry/appr-helm-plugin/releases/download/${APP_REGISTRY_PLUGIN_RELEASE}/helm-registry_linux.tar.gz

RUN apk update && apk add wget openssl git curl bash gettext && \
    mkdir -p /etc/helm/plugins/appr && ln -s /etc/helm ~/.helm && \
    wget https://storage.googleapis.com/kubernetes-helm/helm-${HELM_RELEASE}-linux-amd64.tar.gz -O - | tar -zxv linux-amd64/helm && \
    mv linux-amd64/helm /usr/bin/ && rm -rf linux-amd64 && \
    cd ${HELM_PLUGIN} && wget ${APP_REGISTRY_URL} -O - | tar -zxv && \
    helm plugin list && \
    helm registry list quay.io && \
    apk del curl wget

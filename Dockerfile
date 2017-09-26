FROM alpine:3.6
MAINTAINER Michael Venezia <mvenezia@gmail.com>

ENV HELM_HOME=/etc/helm
ENV HELM_PLUGIN=/etc/helm/plugins
ENV HELM_RELEASE=v2.6.1
ENV HELM_RELEASE_URL=https://storage.googleapis.com/kubernetes-helm/helm-${HELM_RELEASE}-linux-amd64.tar.gz

# Note that the plugin is _not_ the same thing as the binary
# See 
ENV APP_REGISTRY_PLUGIN_RELEASE=v0.7.0
ENV APP_REGISTRY_PLUGIN_URL=https://github.com/app-registry/appr-helm-plugin/releases/download/${APP_REGISTRY_PLUGIN_RELEASE}/helm-registry_linux.tar.gz

# This is the actual appr binary
# See https://github.com/app-registry/appr/releases
ENV APP_REGISTRY_RELEASE=v0.7.4
ENV APP_REGISTRY_URL=https://github.com/app-registry/appr/releases/download/${APP_REGISTRY_RELEASE}/appr-alpine-x64


RUN apk update && apk add wget openssl git curl bash gettext && \
    mkdir -p /etc/helm/plugins/appr && ln -s /etc/helm ~/.helm && \
    wget ${HELM_RELEASE_URL} -O - | tar -zxv linux-amd64/helm && \
    mv linux-amd64/helm /usr/bin/ && rm -rf linux-amd64 && \
    cd ${HELM_PLUGIN} && wget ${APP_REGISTRY_PLUGIN_URL} -O - | tar -zxv && \
    cd registry && wget ${APP_REGISTRY_URL} && mv appr-alpine-x64 appr && chmod a+x appr && \
    helm plugin list && \
    helm registry list quay.io && \
    apk del curl wget

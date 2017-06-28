FROM ubuntu:latest
MAINTAINER Michael Venezia <mvenezia@gmail.com>

ENV HELM_HOME=/etc/helm
ENV HELM_PLUGIN=/etc/helm/plugins
ENV HELM_RELEASE=v2.5.0
ENV APP_REGISTRY_PLUGIN_RELEASE=v0.5.0
ENV APP_REGISTRY_PLUGIN_URL=https://github.com/app-registry/appr/releases/download/${APP_REGISTRY_PLUGIN_RELEASE}/appr-linux-x64
ENV APP_REGISTRY_PLUGIN_YAML_URL=https://raw.githubusercontent.com/app-registry/appr/${APP_REGISTRY_PLUGIN_RELEASE}/appr/commands/plugins/helm/plugin.yaml
ENV APP_REGISTRY_PLUGIN_SCRIPT_URL=https://raw.githubusercontent.com/app-registry/appr/${APP_REGISTRY_PLUGIN_RELEASE}/appr/commands/plugins/helm/cnr.sh

RUN mkdir -p /etc/helm/plugins/appr && ln -s /etc/helm ~/.helm

RUN apt-get update && apt-get install -y wget openssl git gettext-base
RUN wget https://storage.googleapis.com/kubernetes-helm/helm-${HELM_RELEASE}-linux-amd64.tar.gz -O - | tar -zxv linux-amd64/helm && \
    mv linux-amd64/helm /usr/bin/ && rm -rf linux-amd64
WORKDIR /etc/helm/plugins/appr
RUN wget ${APP_REGISTRY_PLUGIN_URL} -O appr && \
    wget ${APP_REGISTRY_PLUGIN_YAML_URL} -O plugin.yaml && \
    wget ${APP_REGISTRY_PLUGIN_SCRIPT_URL} -O appr.sh && \
    chmod +x appr appr.sh
WORKDIR /
RUN helm plugin list && \
    helm registry list quay.io

FROM alpine:3.11

ADD resource/ /opt/resource/
ADD itest/ /opt/itest/

# Install uuidgen
RUN apk add --no-cache ca-certificates curl bash jq util-linux wget

# Install glibc required for autoscaler plugin
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
  wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk && \
  apk add glibc-2.28-r0.apk

# Install Cloud Foundry cli v6
ADD https://packages.cloudfoundry.org/stable?release=linux64-binary&version=6.49.0 /tmp/cf-cli.tgz
RUN mkdir -p /usr/local/bin && \
  tar -xf /tmp/cf-cli.tgz -C /usr/local/bin && \
  cf --version && \
  rm -f /tmp/cf-cli.tgz

# Install Cloud Foundry cli v7
ADD https://packages.cloudfoundry.org/stable?release=linux64-binary&version=7.0.0-beta.30 /tmp/cf7-cli.tgz
RUN mkdir -p /usr/local/bin && \
  tar -xzf /tmp/cf7-cli.tgz -C /usr/local/bin && \
  cf7 --version && \
  rm -f /tmp/cf7-cli.tgz

# Install cf cli Autopilot plugin
ADD https://github.com/contraband/autopilot/releases/download/0.0.8/autopilot-linux /tmp/autopilot-linux
RUN chmod +x /tmp/autopilot-linux && \
  cf install-plugin /tmp/autopilot-linux -f && \
  rm -f /tmp/autopilot-linux

# Install yaml cli
ADD https://github.com/mikefarah/yq/releases/download/3.2.1/yq_linux_amd64 /tmp/yq_linux_amd64
RUN install /tmp/yq_linux_amd64 /usr/local/bin/yq && \
  yq --version && \
  rm -f /tmp/yq_linux_amd64

# Install Pivnet cli
ADD https://github.com/pivotal-cf/pivnet-cli/releases/download/v0.0.77/pivnet-linux-amd64-0.0.77 /tmp/pivnet-cli
RUN install /tmp/pivnet-cli /usr/local/bin/pivnet && \
  pivnet --version && \
  rm -f /tmp/pivnet-cli

# Install PCF Autoscaler cli
RUN pivnet login --api-token=$PIVNET_TOKEN && \
  mkdir /tmp/autoscaler/ && \
  pivnet download-product-files -p pcf-app-autoscaler --glob='*linux64*' --download-dir='/tmp/autoscaler' --release-version='2.0.233' && \
  cf install-plugin /tmp/autoscaler/autoscaler* -f && \
  rm -rf autoscaler/

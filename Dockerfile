FROM alpine:3.11

ADD resource/ /opt/resource/
ADD itest/ /opt/itest/

# Install uuidgen
RUN apk add --no-cache ca-certificates curl bash jq util-linux

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

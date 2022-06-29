# Note: You can use any Debian/Ubuntu based image you want. 
FROM mcr.microsoft.com/vscode/devcontainers/base:buster

# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="false"
# [Option] Enable non-root Docker access in container
ARG ENABLE_NONROOT_DOCKER="true"
# [Option] Use the OSS Moby Engine instead of the licensed Docker Engine
ARG USE_MOBY="true"
# [Option] Engine/CLI Version
ARG DOCKER_VERSION="latest"

ARG OPERATOR_SDK_VERSION="1.21.0"

ARG HELMIFY_VERSION="0.3.14"

# Enable new "BUILDKIT" mode for Docker CLI
ENV DOCKER_BUILDKIT=1

# Install needed packages and setup non-root user. Use a separate RUN statement to add your
# own dependencies. A user of "automatic" attempts to reuse an user ID if one already exists.
ARG USERNAME=automatic
ARG USER_UID=1000
ARG USER_GID=$USER_UID
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apt-get update \
    && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    # Use Docker script from script library to set things up
    && /bin/bash /tmp/library-scripts/docker-in-docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "${USERNAME}" "${USE_MOBY}" "${DOCKER_VERSION}" \
    # Use Docker script from script library to set things up
    && /bin/bash /tmp/library-scripts/operator-sdk.sh   "${OPERATOR_SDK_VERSION}" \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

VOLUME [ "/var/lib/docker" ]

# Setting the ENTRYPOINT to docker-init.sh will start up the Docker Engine 
# inside the container "overrideCommand": false is set in devcontainer.json. 
# The script will also execute CMD if you need to alter startup behaviors.
EXPOSE 8500
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    software-properties-common \
    unzip \
    curl \
    python3-dev \
    python3-pip \
    python3-setuptools \
    build-essential \
    libssl-dev \
    libffi-dev \
    && pip3 install --upgrade pip \
    && pip3 install setuptools ansible-runner-http==1.0.0 ansible-runner==2.2.0 ansible

#  install kind
RUN curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.14.0/kind-$(uname)-amd64" \
    && chmod +x ./kind \
    && mv ./kind /usr/bin/kind

#  install kustomize
RUN curl -LO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v3.2.3/kustomize_kustomize.v3.2.3_linux_amd64 \
    && chmod a+x kustomize_kustomize.v3.2.3_linux_amd64 \
    && mv kustomize_kustomize.v3.2.3_linux_amd64 /usr/local/bin/kustomize

#  install tilt
RUN curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash

#  install ctlptl
RUN curl -LO https://github.com/tilt-dev/ctlptl/releases/download/v0.8.4/ctlptl.0.8.4.linux.x86_64.tar.gz \
    && tar -xzvf ctlptl.0.8.4.linux.x86_64.tar.gz \
    && chmod a+x ctlptl \
    && mv ctlptl /usr/local/bin/ctlptl

# install helmify
RUN curl -LO https://github.com/arttor/helmify/releases/download/v${HELMIFY_VERSION}/helmify_${HELMIFY_VERSION}_Linux_64-bit.tar.gz \
    && tar -xzvf helmify_${HELMIFY_VERSION}_Linux_64-bit.tar.gz \
    && chmod a+x helmify \
    && mv helmify /usr/local/bin/helmify

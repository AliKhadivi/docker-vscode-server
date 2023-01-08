FROM ubuntu:22.04

ENV NVM_DIR=/usr/local/nvm \
    NODE_VERSION=14.21.2
ENV NODE_PATH=$NVM_DIR/v$NODE_VERSION/lib/node_modules \
    PATH=$NVM_DIR/v$NODE_VERSION/bin:$PATH
# hadolint ignore=DL3008
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -y --no-install-recommends \
    # vscode requirements
    gnome-keyring wget curl python3-minimal ca-certificates \
    # development tools
    git build-essential \
    apt-transport-https \
    libssl-dev \
    # clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    curl https://raw.githubusercontent.com/creationix/nvm/v0.39.3/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default && \
    npm i -g @angular/cli && \
    wget -q -O- https://aka.ms/install-vscode-server/setup.sh | sh
    
# copy scripts
COPY src/* /usr/local/bin/

# entrypoint
ENTRYPOINT [ "start-vscode" ]

# expose port
EXPOSE 8000

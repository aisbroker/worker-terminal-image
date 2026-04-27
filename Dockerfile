#
# OCI base image for worker-terminal.
#

FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

USER root

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y \
        # install normal tools
        bash \
        ca-certificates \
        curl \
        git \
        gnupg \
        less \
        nano \
        net-tools \
        nodejs \
        npm \
        openssh-client \
        openssl \
        procps \
        python3 \
        python3-pip \
        rsync \
        tmux \
        ttyd \
        vim \
        wget \
    \
    # install uv \
    && ( curl -LsSf https://astral.sh/uv/install.sh | sh ) \
    \
    # install docker \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && . /etc/os-release \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu ${VERSION_CODENAME} stable" > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y \
        docker-ce-cli \
        docker-compose-plugin \
    \
    # install codex CLI \
    && npm install -g @openai/codex \
    \
    # cleanup \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN    date -u +"%Y-%m-%dT%H:%M:%S%:z" >>      /root/.worker-terminal-image-github-build-was-here \
    && mkdir -p                           /workspace \
    && date -u +"%Y-%m-%dT%H:%M:%S%:z" >> /workspace/.worker-terminal-image-github-build-was-here 

RUN    git config --global user.email "c@example.com" \
    && git config --global user.name "C H" \
    && git config --global pull.rebase false  # merge

WORKDIR /workspace


FROM node:26-bookworm

#== Arguments
ARG CODESERVER_VERSION="4.99.4"
#== Default Environments
ENV APP_ROOT=/var/www/html/
ENV USER=www
ENV GROUP=www
ENV UID=1000
ENV GID=1000
ENV SHELL=/bin/bash

ENV PORT=3000
ENV CODES_PORT=8080
ENV CODES_WORKING_DIR=$APP_ROOT
ENV CODES_USER_DATA_DIR=$APP_ROOT/.vscode
ENV CODES_ENABLE=yes

ENV NPM_GLOBAL_DIR=/home/${USER}/.npm-global

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl \
    git \
    wget \
    nano \
    zip \
    unzip \
    python3 \
    python3-apt \
    ca-certificates \
    openssl \
    make \
    g++ \
    pkg-config \
    default-mysql-client \
    postgresql-client \
    libpq-dev \
    rsync \
    jq \
    dnsutils \
    iputils-ping \
    procps \
    gnupg \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /app

ADD https://github.com/coder/code-server/releases/download/v${CODESERVER_VERSION}/code-server_${CODESERVER_VERSION}_amd64.deb /tmp/
RUN dpkg -i /tmp/code-server_${CODESERVER_VERSION}_amd64.deb \
    && rm /tmp/code-server_${CODESERVER_VERSION}_amd64.deb

RUN npm install -g pnpm@latest corepack@latest \
    && corepack enable \
    && corepack install -g yarn@stable

RUN npm install -g pnpm@12.21.0 corepack@0.34.7 \
    && corepack enable yarn \
    && corepack install -g yarn@4.18.1

#== Adding user
RUN getent group ${GID} || groupadd -g ${GID} ${GROUP}

RUN useradd --system \
    --uid ${UID} \
    --gid ${GROUP} \
    --shell ${SHELL} \
    --create-home \
    --home-dir /home/${USER} \
    ${USER} \
    && adduser ${USER} www-data

#== Setup directories and permissions
RUN mkdir -p ${NPM_GLOBAL_DIR} \
    ${APP_ROOT} \
    /home/${USER}/dev \
    && touch /home/${USER}/dev/log \
    && chown -R ${USER}:${GROUP} \
        /home/${USER} \
        ${APP_ROOT}

COPY scripts /scripts

RUN chmod +x /scripts/docker-entrypoint.sh

#== Configure npm
USER ${USER}

RUN npm config set prefix ${NPM_GLOBAL_DIR} \
    && echo "export PATH=${NPM_GLOBAL_DIR}/bin:$PATH" >> /home/${USER}/.bashrc \
    && echo "export PATH=${NPM_GLOBAL_DIR}/bin:$PATH" >> /home/${USER}/.profile

WORKDIR ${APP_ROOT}
EXPOSE ${PORT}

#=== Start
CMD ["/bin/bash", "-c", "/scripts/docker-entrypoint.sh"]

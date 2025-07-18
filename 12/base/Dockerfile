FROM node:12.12-buster

#== Arguments
ARG CODESERVER_VERSION="4.99.4"
#== Default Environments
ENV APP_ROOT=/var/www/html/
ENV USER=www
ENV GROUP=www
ENV UID=1000
ENV GID=1000
ENV SHELL=/bin/bash

ENV CODES_PORT=8080
ENV CODES_WORKING_DIR=$APP_ROOT
ENV CODES_USER_DATA_DIR=$APP_ROOT/.vscode
ENV CODES_ENABLE=yes

ENV NPM_GLOBAL_DIR=/home/${USER}/.npm-global

RUN apt-get update && \
    apt-get install -y sudo curl git wget nano apt-utils zip unzip python3 python3-apt && \
    mkdir -p /app

ADD https://github.com/coder/code-server/releases/download/v${CODESERVER_VERSION}/code-server_${CODESERVER_VERSION}_amd64.deb /tmp/
RUN dpkg -i /tmp/code-server_${CODESERVER_VERSION}_amd64.deb \
    && rm /tmp/code-server_${CODESERVER_VERSION}_amd64.deb

#== Adding user
RUN getent group ${GID} || groupadd -g ${GID} ${GROUP}
RUN useradd --system --shell /bin/bash --create-home --home-dir /home/${USER} ${USER} \
    && adduser ${USER} www-data \
    && usermod -aG sudo ${USER} \
    && echo "www ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USER}
RUN mkdir -p $NPM_GLOBAL_DIR \
    && npm config set prefix $NPM_GLOBAL_DIR \
    && echo "export PATH=$NPM_GLOBAL_DIR/bin:$PATH" >> /home/${USER}/.bashrc \
    && echo "export PATH=$NPM_GLOBAL_DIR/bin:$PATH" >> /home/${USER}/.profile

RUN mkdir ~/dev
RUN touch ~/dev/log
COPY scripts /scripts
RUN sudo chmod +x /scripts/docker-entrypoint.sh

WORKDIR ${APP_ROOT}
EXPOSE 3000

#=== Start
CMD ["/bin/bash", "-c", "/scripts/docker-entrypoint.sh"]

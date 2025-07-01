FROM node:24-bookworm

#== Arguments
ARG CODESERVER_VERSION="4.99.4"
ARG PYTHON_VERSION="3.11.2"
#== Default Environments
ENV APP_ROOT /var/www/html/
ENV USER www
ENV GROUP www
ENV UID 1000
ENV GID 1000
ENV SHELL /bin/bash

ENV CODES_PORT 8080
ENV CODES_WORKING_DIR $APP_ROOT
ENV CODES_USER_DATA_DIR $APP_ROOT/.vscode
ENV CODES_ENABLE yes

#== Update the repository sources list and install dependencies
RUN apt-get update \
    && apt-get install -y curl git wget nano apt-utils zip unzip python3 python3-apt \
    && apt-get -y autoclean

#== Install python
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    gcc \
    make \
    openssl \
    libffi-dev \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libgdbm-dev \
    libdb5.3-dev \
    libbz2-dev \
    libexpat1-dev \
    liblzma-dev \
    tk-dev \
    uuid-dev \
    && rm -rf /var/lib/apt/lists/*
RUN curl -O https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar -xvf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make altinstall
RUN python3 --version

#== Install apache2
# RUN apt-get install -y sudo

#== Adding user
# RUN groupadd -g ${GID} ${GROUP} \
#     && useradd --system --shell /bin/bash --uid ${UID} --gid ${GROUP} --create-home --home-dir /home/${USER} ${USER} \
#     && adduser ${USER} www-data \
#     && apt install -y sudo \
#     && usermod -aG sudo ${USER} \
#     && echo "www ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN mkdir -p ${APP_ROOT} \
    && chown -R ${UID}:${GID} ${APP_ROOT}

#== Install Codeserver [AMD Chip]
ADD https://github.com/coder/code-server/releases/download/v${CODESERVER_VERSION}/code-server_${CODESERVER_VERSION}_amd64.deb /tmp/
RUN dpkg -i /tmp/code-server_${CODESERVER_VERSION}_amd64.deb \
    && rm /tmp/code-server_${CODESERVER_VERSION}_amd64.deb

COPY scripts /scripts
RUN npm --version
RUN npm install pm2 -g

USER ${USER}
WORKDIR ${APP_ROOT}
EXPOSE 80

#== Start.
ENTRYPOINT ["/scripts/docker-entrypoint.sh"]
CMD ["/bin/bash", "-c", "tail -f /dev/null"]

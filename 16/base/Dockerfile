FROM debian:latest

#== Default Environments
ENV APP_ROOT /var/www/html/
ENV USER www
ENV GROUP www
ENV UID 1000
ENV GID 1000
ENV SHELL /bin/bash

#== Update the repository sources list and install dependencies
RUN apt-get update \
    && apt-get install -y curl git \
    && apt-get -y autoclean

#== Install apache2
RUN apt-get install apache2 python3 -y
RUN apt-get install apache2-utils -y
RUN  apt-get install -y sudo

#== Adding user
RUN groupadd -g ${GID} ${GROUP} \
    && useradd --system --shell /bin/bash --uid ${UID} --gid ${GROUP}  --create-home --home-dir /home/${USER} ${USER} \
    && adduser ${USER} www-data \
    && apt install -y sudo \
    && usermod -aG sudo ${USER} \
    && echo "www    ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN mkdir -p ${APP_ROOT} \
    && chown -R ${UID}:${GID} ${APP_ROOT}

#== Install Codeserver [AMD Chip]
ARG CODESERVER_VERSION="4.9.1"
ADD https://github.com/coder/code-server/releases/download/v${CODESERVER_VERSION}/code-server_${CODESERVER_VERSION}_amd64.deb /tmp/
RUN dpkg -i /tmp/code-server_${CODESERVER_VERSION}_amd64.deb \
    && rm /tmp/code-server_${CODESERVER_VERSION}_amd64.deb


#== Configure apache2
COPY scripts /scripts
COPY templates /templates

#== Enable mode by default
RUN  a2enmod rewrite remoteip proxy proxy_http proxy_balancer lbmethod_byrequests

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

USER ${USER}
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 16.14.2

RUN sudo mkdir -p ${NVM_DIR} && sudo chmod 777 -R ${NVM_DIR}
#== Install nvm with node and npm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.30.1/install.sh | bash \
    &&  source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV PATH="${NVM_DIR}/versions/node/v${NODE_VERSION}/bin/:${PATH}"

RUN npm install pm2 -g

WORKDIR ${APP_ROOT}
EXPOSE 80

#== Start apache.
CMD ["sudo", "-E", "/bin/bash", "/scripts/apache-start.sh" ]

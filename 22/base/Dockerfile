FROM node:22-bookworm

#== Arguments
ARG CODESERVER_VERSION="4.99.4"
#== Default Environments
ENV APP_ROOT /var/www/html/
ENV USER www
ENV GROUP www
ENV UID 1000
ENV GID 1000
ENV SHELL /bin/bash

ENV CODES_PORT 8080
ENV CODES_WORKING_DIR $APP_ROOT
ENV CODES_ENABLE yes

RUN apt-get update && apt-get install -y curl git bash wget nano apt-utils zip unzip \
    && apt-get -y autoclean
RUN apt-get install -y sudo

#== Install Codeserver [AMD Chip]
ADD https://github.com/coder/code-server/releases/download/v${CODESERVER_VERSION}/code-server_${CODESERVER_VERSION}_amd64.deb /tmp/
RUN dpkg -i /tmp/code-server_${CODESERVER_VERSION}_amd64.deb \
    && rm /tmp/code-server_${CODESERVER_VERSION}_amd64.deb
#== Install Codeserver [ARM Chip]
# ADD https://github.com/coder/code-server/releases/download/v${CODESERVER_VERSION}/code-server_${CODESERVER_VERSION}_arm64.deb /tmp/
# RUN dpkg -i /tmp/code-server_${CODESERVER_VERSION}_arm64.deb \
#     && rm /tmp/code-server_${CODESERVER_VERSION}_arm64.deb
#== Adding user
# RUN groupadd -g ${GID} ${GROUP}
    # && useradd --system --shell /bin/bash --uid ${UID} --gid ${GROUP} --create-home --home-dir /home/${USER} ${USER} \
    # && adduser ${USER} www-data \
    # && usermod -aG sudo ${USER} \
    # && echo "www ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p ${APP_ROOT} \
    && chown -R ${UID}:${GID} ${APP_ROOT}

WORKDIR ${APP_ROOT}
#== Config nodejs
USER ${USER}
RUN npm install pm2 -g

# Expose Port
EXPOSE 3000
EXPOSE 8080

#== Start server.
CMD ["sudo", "-E", "/bin/bash", "/scripts/apache-start.sh" ]

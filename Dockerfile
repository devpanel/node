FROM debian:latest


#== Default Environments
ENV APP_ROOT /var/www/html/


# update the repository sources list
# and install dependencies
RUN apt-get update \
    && apt-get install -y curl \
    && apt-get -y autoclean


RUN apt-get install apache2 -y
RUN apt-get install apache2-utils -y





EXPOSE 80
CMD [“apache2ctl”, “-D”, “FOREGROUND”]

#!/bin/bash
# Turn on bash's job control

sudo cp /templates/apache2.conf /etc/apache2/apache2.conf
sudo cp /templates/000-default.conf /etc/apache2/sites-enabled/000-default.conf
PM2_START_SCRIPT=$APP_ROOT/ecosystem.config.js

# Custom Environment variables in /etc/apache2/sites-enabled/000-default.conf
[ ! -z "$WEB_ROOT" ] && sudo sed -i "s|{{WEB_ROOT}}|${WEB_ROOT}|" /etc/apache2/sites-enabled/000-default.conf
[ ! -z "$SERVER_NAME" ] && sudo sed -i "s|{{SERVER_NAME}}|${SERVER_NAME}|" /etc/apache2/sites-enabled/000-default.conf

# Custom Environment variable in /etc/apache2/apache2.conf
[ ! -z "$WEB_ROOT" ] && sudo sed -i "s|{{WEB_ROOT}}|${WEB_ROOT}|" /etc/apache2/apache2.conf

set -m
if [[ "$CODES_ENABLE" == "yes" ]]; then
# Start the primary process and put it in the background
sudo apachectl -D FOREGROUND &
# Start the helper process
if [[ "$CODES_AUTH" == "yes" ]]; then
sudo -u www -E -- code-server --port $CODES_PORT --host 0.0.0.0 $CODES_WORKING_DIR --user-data-dir=$CODES_USER_DATA_DIR
else
sudo -u www -E -- code-server --auth none --port $CODES_PORT --host 0.0.0.0 $CODES_WORKING_DIR --user-data-dir=$CODES_USER_DATA_DIR
fi
# and leave it there
fg %1

[ -f "$PM2_START_SCRIPT" ] && pm2 startOrRestart $PM2_START_SCRIPT
else
# Start the primary process and put it in the background
sudo  apachectl -D FOREGROUND
[ -f "$PM2_START_SCRIPT" ] && pm2 startOrRestart $PM2_START_SCRIPT
fi

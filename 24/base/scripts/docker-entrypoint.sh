#!/bin/bash
# Turn on bash's job control

PM2_START_SCRIPT=$APP_ROOT/ecosystem.config.js

set -m
if [[ "$CODES_ENABLE" == "yes" ]]; then
# Start the primary process and put it in the background
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
[ -f "$PM2_START_SCRIPT" ] && pm2 startOrRestart $PM2_START_SCRIPT
fi

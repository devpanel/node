#!/bin/bash
# Turn on bash's job control

set -m
# Install custom packages if have
[ -f "$APP_ROOT/.devpanel/custom_package_installer.sh" ] && /bin/bash $APP_ROOT/.devpanel/custom_package_installer.sh  >> /tmp/custom_package_installer.log
if [[ "$CODES_ENABLE" == "yes" ]]; then
# Start the helper process
if [[ "$CODES_AUTH" == "yes" ]]; then
sudo -u www -E -- code-server --port $CODES_PORT --host 0.0.0.0 $CODES_WORKING_DIR --user-data-dir=$CODES_USER_DATA_DIR &
else
sudo -u www -E -- code-server --auth none --port $CODES_PORT --host 0.0.0.0 $CODES_WORKING_DIR --user-data-dir=$CODES_USER_DATA_DIR &
fi
fi

if [ -z "$DP_APP_CMD" ]; then
  echo "❌ DP_APP_CMD is not set. Exiting."
  exit 1
fi

# Chạy lệnh từ biến DP_APP_CMD
echo "🚀 Running: $DP_APP_CMD"
eval "$DP_APP_CMD"

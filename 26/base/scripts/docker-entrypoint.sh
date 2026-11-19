#!/bin/bash

set -m

mkdir -p "$APP_ROOT/.logs"
# Install custom packages if available
if [ -f "$APP_ROOT/.devpanel/custom_package_installer.sh" ]; then
  /bin/bash "$APP_ROOT/.devpanel/custom_package_installer.sh" >> $APP_ROOT/.logs/custom_package_installer.log 2>&1
fi

# Start code-server
if [[ "$CODES_ENABLE" == "yes" ]]; then
  if [[ "$CODES_AUTH" == "yes" ]]; then
    code-server --port "$CODES_PORT" --host 0.0.0.0 "$CODES_WORKING_DIR" --user-data-dir="$CODES_USER_DATA_DIR" &
  else
    code-server --auth none --port "$CODES_PORT" --host 0.0.0.0 "$CODES_WORKING_DIR" --user-data-dir="$CODES_USER_DATA_DIR" &
  fi
fi

if [ -z "$DP_APP_CMD" ]; then
    echo "❌ DP_APP_CMD is not set. Exiting."
    exit 1
fi

# Run application command
echo "🚀 Running: $DP_APP_CMD"
cd "$WEB_ROOT" || exit 1
eval "$DP_APP_CMD"
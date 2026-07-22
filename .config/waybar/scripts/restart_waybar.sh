#!/bin/bash
# Restart waybar via the systemd user service if it exists, else launch it
# directly. Avoids ending up with two instances.

service_name=waybar.service

if systemctl --user list-unit-files --quiet "$service_name"; then
    echo "service exists, restarting"
    systemctl --user restart "$service_name"
else
    echo "service does not exist, executing waybar directly"
    pkill -x waybar; waybar
fi

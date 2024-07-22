#!/bin/bash

service_name=waybar.service

if systemctl --user list-unit-files --quiet "$service_name"; then
    echo "service exists, restarting"
    systemctl --user restart "$service_name"
else
    echo "service does not exist, executing waybar directly"
    pkill -x waybar; waybar
fi

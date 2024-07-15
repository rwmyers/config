#!/bin/bash

service_name=waybar.service

if systemctl --user is-active --quiet "$service_name"; then
    systemctl --user stop "$service_name"
    systemctl --user start "$service_name"
else
    pkill -x waybar; waybar
fi

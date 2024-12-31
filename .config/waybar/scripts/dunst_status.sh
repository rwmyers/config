#!/usr/bin/env bash

state=$( dunstctl is-paused )

if [[ $state == "true" ]];
then
    echo '{ "text": "󰂛", "tooltip": "Dunst is paused.", "class": "disabled" }'
else
    echo '{ "text": "󰂚", "tooltip": "Dunst is enabled.", "class": "enabled" }'
fi

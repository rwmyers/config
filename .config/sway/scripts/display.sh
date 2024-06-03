#!/usr/bin/env bash
dir=$HOME/.config/sway
script=$dir/display_mode
op=$(python3 $script | wofi -i --dmenu)

python3 $script $op | wofi -i --dmenu

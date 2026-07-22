#!/bin/zsh

# Remove the retired sway config. Unconditional — no Nix gate. The apt sway
# package is deliberately left installed: waybar and swaybg depend on it, and
# swaylock/swayidle/swaybg are still used by hyprland.
# Delete this file once every machine has been cleaned.
source $HOME/src/config/install/common.sh

if [ -L "$HOME/.config/sway" ] || [ -d "$HOME/.config/sway" ]
then
    print_note " -- Removing retired sway config (~/.config/sway)"
    rm -rf "$HOME/.config/sway"
fi

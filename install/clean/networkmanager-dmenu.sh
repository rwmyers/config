#!/bin/zsh

# Remove networkmanager-dmenu, replaced by bin/wifi-menu (nmcli + walker). It
# never worked here anyway — it needs PyGObject (`gi`), which the Nix python3
# lacks. Unconditional — no Nix gate. Delete this file once every machine is cleaned.
source $HOME/src/config/install/common.sh

removed=0
for p in \
    "$HOME/.local/share/networkmanager-dmenu" \
    "$HOME/.config/networkmanager-dmenu" \
    "$HOME/bin/networkmanager_dmenu"
do
    if [ -e "$p" ] || [ -L "$p" ]
    then
        rm -rf "$p"
        removed=1
    fi
done
[ "$removed" -eq 1 ] && print_note " -- Removed networkmanager-dmenu (replaced by wifi-menu)"

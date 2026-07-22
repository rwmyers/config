#!/bin/zsh

# Remove leftover polybar cruft (polybar was retired). Unconditional — no Nix
# gate. Delete this file once every machine has been cleaned.
source $HOME/src/config/install/common.sh

# Config symlink/dir left over from when polybar was linked in.
if [ -L "$HOME/.config/polybar" ] || [ -d "$HOME/.config/polybar" ]
then
    print_note " -- Removing leftover polybar config (~/.config/polybar)"
    rm -rf "$HOME/.config/polybar"
fi

# The apt polybar package.
if dpkg -s polybar > /dev/null 2>&1
then
    print_note " -- Removing polybar package"
    sudo apt -y remove polybar
fi

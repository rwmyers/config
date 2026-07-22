#!/bin/zsh

# Remove leftover rofi cruft (rofi was retired). Unconditional — no Nix gate.
# Delete this file once every machine has been cleaned.
source $HOME/src/config/install/common.sh

# Config symlink/dir left over from when rofi was linked in.
if [ -L "$HOME/.config/rofi" ] || [ -d "$HOME/.config/rofi" ]
then
    print_note " -- Removing leftover rofi config (~/.config/rofi)"
    rm -rf "$HOME/.config/rofi"
fi

# The apt rofi package.
if dpkg -s rofi > /dev/null 2>&1
then
    print_note " -- Removing rofi package"
    sudo apt -y remove rofi
fi

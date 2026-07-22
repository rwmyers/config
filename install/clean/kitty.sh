#!/bin/zsh

# Remove leftover kitty cruft (kitty was retired). Unconditional — no Nix gate.
# Delete this file once every machine has been cleaned.
source $HOME/src/config/install/common.sh

# Config symlink/dir left over from when kitty was linked in.
if [ -L "$HOME/.config/kitty" ] || [ -d "$HOME/.config/kitty" ]
then
    print_note " -- Removing leftover kitty config (~/.config/kitty)"
    rm -rf "$HOME/.config/kitty"
fi

# The apt kitty package.
if dpkg -s kitty > /dev/null 2>&1
then
    print_note " -- Purging kitty package"
    sudo apt -y purge kitty
fi

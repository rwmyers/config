#!/bin/zsh

# Remove nvm now that Node comes from Nix (nix/home.nix: nodejs). nvm's shell
# init was dropped from .zshrc. Unconditional — no Nix gate. Delete this file
# once every machine is cleaned.
source $HOME/src/config/install/common.sh

if [ -d "$HOME/.nvm" ]
then
    print_note " -- Removing unused nvm (~/.nvm); Node now comes from Nix"
    rm -rf "$HOME/.nvm"
fi

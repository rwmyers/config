#!/bin/zsh

# Remove the unused oh-my-zsh clone (it was cloned but never sourced).
# Unconditional — no Nix gate. Delete this file once every machine is cleaned.
source $HOME/src/config/install/common.sh

if [ -d "$HOME/.oh-my-zsh" ]
then
    print_note " -- Removing unused oh-my-zsh (~/.oh-my-zsh)"
    rm -rf "$HOME/.oh-my-zsh"
fi

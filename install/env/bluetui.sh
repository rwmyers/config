#!/bin/zsh

# TUI for managing bluetooth devices (https://github.com/pythops/bluetui)
source $HOME/src/config/install/common.sh

if [ ! -e "$HOME/.cargo/bin/bluetui" ]
then
    print_note "Installing bluetui"
    cargo install bluetui 
fi

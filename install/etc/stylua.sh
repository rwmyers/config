#!/bin/zsh

source $HOME/src/config/install/common.sh

if [ ! -e "$HOME/.cargo/bin/stylua" ]
then
    print_note "Installing stylua"
    cargo install stylua
fi

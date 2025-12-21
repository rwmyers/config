#!/bin/zsh

source $HOME/src/config/install/common.sh

if [ ! -e "$HOME/.cargo/bin/taplo" ]
then
    print_note "Installing taplo"
    cargo install taplo-cli
fi

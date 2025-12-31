#!/bin/zsh

# TUI for network management (https://github.com/pythops/impala)
source $HOME/src/config/install/common.sh

if [ ! -e "$HOME/.cargo/bin/impala" ]
then
    print_note "Installing impala"
    cargo install impala
fi

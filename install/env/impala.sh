#!/bin/zsh

# TUI for network management (https://github.com/pythops/impala).
# Linux-only — it drives iwd, which doesn't exist on macOS.
source $HOME/src/config/install/common.sh

[[ "$OSTYPE" == "linux-gnu"* ]] || exit 0

if [ ! -e "$HOME/.cargo/bin/impala" ]
then
    print_note "Installing impala"
    cargo install impala
fi

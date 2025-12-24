#!/bin/zsh

source $HOME/src/config/install/common.sh

if [ ! -e "$HOME/src/clippy" ]
then
    print_note " -- Installing clippy & python venv"
    apt install python3.13-venv
    pushd $HOME/src/
    git clone https://github.com/nedn/clippy
    popd
else
    print_note " -- Updating clippy"
    pushd $HOME/src/clippy
    git pull
    popd
fi

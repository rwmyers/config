#!/bin/zsh
# Python package management tool (https://github.com/astral-sh/uv)
source $HOME/src/config/install/common.sh

if [ ! -e "/usr/bin/snap" ]
then
    print_note " -- Installing snap"
    sudo apt install snapd
    sudo snap install core
fi

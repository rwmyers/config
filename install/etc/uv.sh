#!/bin/zsh
# Python package management tool (https://github.com/astral-sh/uv)
source $HOME/src/config/install/common.sh

if [ ! -e "$HOME/.local/bin/uv" ]
then
    print_note " -- Installing uv"
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    print_note " -- Updating uv"
    uv self update
fi

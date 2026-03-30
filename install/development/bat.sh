#!/bin/zsh

# bat - A cat clone with syntax highlighting and git integration
# https://github.com/sharkdp/bat

source $HOME/src/config/install/common.sh

install_linux_package batcat bat

## bat link from batcat
if ! type "bat" > /dev/null;
then
    ln -s $(which batcat) ~/.local/bin/bat
fi

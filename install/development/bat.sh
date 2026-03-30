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

# bat configuration
if [ ! -d "$HOME/.config/bat" ]
then
    print_note " -- Linking bat configuration"
    ln -s $HOME/src/config/.config/bat ~/.config/bat
fi

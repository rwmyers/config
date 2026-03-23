#!/bin/zsh
# Go language installation
source $HOME/src/config/install/common.sh

if [ ! -e "/usr/bin/go" ]
then
    print_note " -- Installing golang"
    sudo apt install golang
fi

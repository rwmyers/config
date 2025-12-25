#!/bin/zsh

source $HOME/src/config/install/common.sh

if [ ! -e "/snap/bin/spotify" ]
then
    print_note " -- Installing spotify"
    sudo snap install spotify
fi

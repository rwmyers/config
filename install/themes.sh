#!/bin/zsh

source install/common.sh

if [ ! -e "$HOME/themes" ]
then
    print_note "Linking themes"
    sudo ln -s $SRC_ROOT/themes $HOME/themes
fi

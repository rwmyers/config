#!/bin/zsh

source install/common.sh

ln -snf $SRC_ROOT/themes $HOME/themes

# btop theme linkage
mkdir -p $HOME/.config/btop/themes
ln -snf $HOME/themes/current/btop.theme $HOME/.config/btop/themes/current.theme

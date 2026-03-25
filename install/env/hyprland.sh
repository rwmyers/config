#!/bin/zsh

# A tool for shell script input and output (https://github.com/charmbracelet/gum)
source $HOME/src/config/install/common.sh

install_linux_package hyprland

if [ ! -d "$HOME/.config/hypr/" ]
then
    print_note " -- Creating hyprland config links"
    mkdir -p ~/.config/hypr
    ln -s $SRC_ROOT/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf
fi

if [ ! -d "$HOME/.config/hypr/local" ]
then
    print_note " -- Creating local configs for hyprland"
    mkdir -p ~/.config/hypr/local
    cp $SRC_ROOT/.config/hypr/local/* ~/.config/hypr/local
fi

if [ ! -d "$HOME/.config/hypr/hyprland" ]
then
    print_note " -- Linking root hyprland folder"
    ln -s $SRC_ROOT/.config/hypr/hyprland ~/.config/hypr/hyprland
fi

if [ ! -d "$HOME/.config/hypr/config.d" ]
then
    print_note " -- Creating hypr config.d link"
    ln -s $SRC_ROOT/.config/hypr/config.d ~/.config/hypr/config.d
fi

#!/bin/zsh

# Remove pre-flatpak Discord installs (snap/apt). Gated on the flatpak
# existing, so we never leave the machine Discord-less.
source $HOME/src/config/install/common.sh

[[ "$OSTYPE" == "linux-gnu"* ]] || exit 0

flatpak info com.discordapp.Discord > /dev/null 2>&1 || exit 0

if type snap > /dev/null 2>&1 && snap list discord > /dev/null 2>&1
then
    print_note " -- Removing snap discord"
    sudo snap remove discord
fi

if dpkg -s discord > /dev/null 2>&1
then
    print_note " -- Removing apt discord"
    sudo apt -y remove discord
fi

#!/bin/zsh

# Remove pre-flatpak Spotify installs (snap/apt). Gated on the flatpak
# existing, so we never leave the machine Spotify-less.
source $HOME/src/config/install/common.sh

[[ "$OSTYPE" == "linux-gnu"* ]] || exit 0

flatpak info com.spotify.Client > /dev/null 2>&1 || exit 0

if type snap > /dev/null 2>&1 && snap list spotify > /dev/null 2>&1
then
    print_note " -- Removing snap spotify"
    sudo snap remove spotify
fi

if dpkg -s spotify-client > /dev/null 2>&1
then
    print_note " -- Removing apt spotify-client"
    sudo apt -y remove spotify-client
fi

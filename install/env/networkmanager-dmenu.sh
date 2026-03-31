#!/usr/bin/env zsh

source "$(dirname "$0")/../common.sh"

INSTALL_DIR="$HOME/.local/share/networkmanager-dmenu"

if [ ! -d "$INSTALL_DIR" ]; then
    print_note "Cloning networkmanager-dmenu"
    git clone https://github.com/firecat53/networkmanager-dmenu.git "$INSTALL_DIR"
else
    print_note "Updating networkmanager-dmenu"
    pushd "$INSTALL_DIR"
    git pull
    popd
fi

ln -sf "$INSTALL_DIR/networkmanager_dmenu" "$HOME/bin/networkmanager_dmenu"

if [ ! -d "$HOME/.config/networkmanager-dmenu" ]; then
    print_note " -- Linking networkmanager-dmenu config"
    ln -s ~/src/config/.config/networkmanager-dmenu ~/.config/networkmanager-dmenu
fi

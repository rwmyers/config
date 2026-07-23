#!/bin/zsh

# kmonad system setup + config link. Runs only on Linux when the "kmonad"
# optional feature is enabled. The binary itself comes from Nix (home.packages,
# gated on the same feature); this handles the uinput/udev/group access Nix
# can't manage, plus linking the config.
source $HOME/src/config/install/common.sh

[[ "$OSTYPE" == "linux-gnu"* ]] || exit 0
feature_enabled kmonad || exit 0

# uinput access: kernel module, groups, udev rule. One-time; the udev rule's
# presence gates the whole block so re-runs are no-ops.
UDEV_RULE="/etc/udev/rules.d/40-kmonad.rules"
if [ ! -f "$UDEV_RULE" ]
then
    print_note " -- Setting up kmonad uinput access"
    sudo modprobe uinput
    sudo groupadd -f uinput
    sudo usermod -aG input,uinput $USER
    echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' \
        | sudo tee "$UDEV_RULE" > /dev/null
    print_note " -- Added input/uinput groups; log out and back in for it to take effect."
fi

# Config link.
if [ ! -e "$HOME/.config/kmonad" ]
then
    print_note " -- Linking kmonad config"
    ln -s $SRC_ROOT/.config/kmonad/ ~/.config/kmonad
fi

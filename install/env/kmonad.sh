#!/bin/zsh

# kmonad system setup + service. Runs only on Linux when the "kmonad" optional
# feature is enabled. The binary comes from Nix (home.packages, gated on the same
# feature); this handles the uinput/udev/group access Nix can't, links the
# config, and runs kmonad as a user service.
source $HOME/src/config/install/common.sh

[[ "$OSTYPE" == "linux-gnu"* ]] || exit 0
feature_enabled kmonad || exit 0

# uinput access: load the module now and on boot, add the groups, and a udev rule
# granting the uinput group access. Gated on the rule's presence so re-runs are
# no-ops.
UDEV_RULE="/etc/udev/rules.d/70-kmonad.rules"
if [ ! -f "$UDEV_RULE" ]
then
    print_note " -- Setting up kmonad uinput access"
    sudo modprobe uinput
    echo "uinput" | sudo tee /etc/modules-load.d/uinput.conf > /dev/null
    sudo groupadd -f uinput
    sudo usermod -aG input,uinput $USER
    echo 'KERNEL=="uinput", SUBSYSTEM=="misc", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' \
        | sudo tee "$UDEV_RULE" > /dev/null
    sudo udevadm control --reload-rules
    sudo udevadm trigger
    print_note " -- Added input/uinput groups; log out and back in for it to take effect."
fi

# Config link.
if [ ! -e "$HOME/.config/kmonad" ]
then
    print_note " -- Linking kmonad config"
    ln -s $SRC_ROOT/.config/kmonad/ ~/.config/kmonad
fi

# Enable + start the user service (unit deployed via the systemd config link).
if ! systemctl --user is-enabled kmonad.service > /dev/null 2>&1
then
    print_note " -- Enabling kmonad user service"
    systemctl --user daemon-reload
    systemctl --user enable --now kmonad.service
fi

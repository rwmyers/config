#!/bin/zsh

# kmonad system setup + service. Runs only on Linux when the "kmonad" optional
# feature is enabled. The binary comes from Nix (home.packages, gated on the same
# feature); this handles the uinput/udev/group access Nix can't, generates the
# machine-local config (detecting this machine's keyboard), and runs kmonad as a
# user service.
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

# Old setups symlinked ~/.config/kmonad to the repo; we now generate the config
# from a template with this machine's keyboard device, so replace the symlink.
[ -L "$HOME/.config/kmonad" ] && rm "$HOME/.config/kmonad"
mkdir -p ~/.config/kmonad

# Pick the keyboard device once (stored in .device). To re-pick (new keyboard),
# delete ~/.config/kmonad/.device and re-run.
DEVICE_FILE="$HOME/.config/kmonad/.device"
if [ ! -f "$DEVICE_FILE" ]
then
    kbds=(/dev/input/by-id/*-event-kbd(N))
    if [ ${#kbds} -eq 0 ]
    then
        print_error " -- No keyboard devices under /dev/input/by-id/*-event-kbd"
    elif [ ${#kbds} -eq 1 ]
    then
        echo "$kbds[1]" > "$DEVICE_FILE"
    else
        print_note " -- Multiple keyboards found; pick the one for kmonad"
        choice=$(printf '%s\n' ${kbds:t} | gum choose --header="kmonad keyboard device")
        [ -n "$choice" ] && echo "/dev/input/by-id/$choice" > "$DEVICE_FILE"
    fi
fi

# Generate the config from the template + chosen device (regenerated each run so
# template edits propagate).
if [ -f "$DEVICE_FILE" ]
then
    device=$(cat "$DEVICE_FILE")
    print_note " -- Generating kmonad config for ${device:t}"
    sed "s|@KBD_DEVICE@|$device|" "$SRC_ROOT/.config/kmonad/mezner.kbd.tmpl" > ~/.config/kmonad/mezner.kbd
fi

# Enable (for boot) and (re)start to apply the current config.
systemctl --user daemon-reload
systemctl --user enable kmonad.service > /dev/null 2>&1
systemctl --user restart kmonad.service

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
    # by-id only lists devices with unique hardware IDs (USB/Bluetooth); internal
    # laptop keyboards (i8042) only appear under by-path, so fall back to that.
    kbds=(/dev/input/by-id/*-event-kbd(N))
    [ ${#kbds} -eq 0 ] && kbds=(/dev/input/by-path/*-event-kbd(N))
    if [ ${#kbds} -eq 0 ]
    then
        print_error " -- No keyboard devices under /dev/input/{by-id,by-path}/*-event-kbd"
    elif [ ${#kbds} -eq 1 ]
    then
        echo "$kbds[1]" > "$DEVICE_FILE"
    else
        # Multiple keyboards (e.g. a module exposing several interfaces): detect
        # the real one by reading all candidates while the user presses a key —
        # whichever emits the most events wins. Stop kmonad first so it isn't
        # holding a grab on any of them.
        systemctl --user stop kmonad.service > /dev/null 2>&1
        print_note " -- Multiple keyboards found. Press a few keys on the one you"
        print_note "    want kmonad to control (~5 seconds)..."
        probe=$(mktemp -d)
        for i in {1..${#kbds}}
        do
            ( timeout 5 cat "$kbds[$i]" > "$probe/$i" 2>/dev/null ) &
        done
        wait
        best=""
        max=0
        for i in {1..${#kbds}}
        do
            sz=$(wc -c < "$probe/$i" 2>/dev/null)
            if [ "${sz:-0}" -gt "$max" ]
            then
                max=$sz
                best="$kbds[$i]"
            fi
        done
        rm -rf "$probe"
        if [ -n "$best" ] && [ "$max" -gt 0 ]
        then
            print_note " -- Detected keyboard: ${best:t}"
            echo "$best" > "$DEVICE_FILE"
        else
            print_error " -- No key events detected; leaving kmonad unconfigured (re-run to retry)."
        fi
    fi
fi

# Generate the config from the template + chosen device, but only rewrite it (and
# restart kmonad) when the result actually changed — so template edits propagate
# while unchanged re-runs stay quiet and don't bounce the service.
changed=0
if [ -f "$DEVICE_FILE" ]
then
    device=$(cat "$DEVICE_FILE")
    config="$HOME/.config/kmonad/mezner.kbd"
    new=$(mktemp)
    sed "s|@KBD_DEVICE@|$device|" "$SRC_ROOT/.config/kmonad/mezner.kbd.tmpl" > "$new"
    if cmp -s "$new" "$config"
    then
        rm -f "$new"
    else
        print_note " -- Generating kmonad config for ${device:t}"
        mv "$new" "$config"
        changed=1
    fi
fi

# Enable for boot; (re)start only when the config changed or it isn't running.
systemctl --user daemon-reload
systemctl --user enable kmonad.service > /dev/null 2>&1
if [ "$changed" -eq 1 ] || ! systemctl --user is-active --quiet kmonad.service
then
    systemctl --user restart kmonad.service
fi

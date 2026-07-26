#!/bin/zsh

# 1Password (https://1password.com/). Linux-only, installed from the official
# .deb (https://support.1password.com/install-linux/), which self-configures
# its own apt repo so future updates flow through apt.
source $HOME/src/config/install/common.sh

[[ "$OSTYPE" == "linux-gnu"* ]] || exit 0

if [ ! -e "/usr/bin/1password" ]
then
    print_note " -- Installing 1password"
    tmp=$(mktemp -d)
    curl -fsSL -o "$tmp/1password.deb" \
        https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb
    sudo apt install -y "$tmp/1password.deb"
    rm -rf "$tmp"
fi

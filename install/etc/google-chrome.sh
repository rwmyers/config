#!/bin/zsh

# Google Chrome (https://www.google.com/chrome/).
# Linux-only, installed from Google's .deb rather than Nix: the Nix build's
# chrome-sandbox can't be setuid root in the read-only store, so it aborts
# under Ubuntu's unprivileged-userns restriction. The .deb installs
# chrome-sandbox as root:root 4755, which sandboxes correctly, and it
# self-configures its own apt repo so future updates flow through apt.
source $HOME/src/config/install/common.sh

[[ "$OSTYPE" == "linux-gnu"* ]] || exit 0

if [ ! -e "/usr/bin/google-chrome" ]
then
    print_note " -- Installing google-chrome"
    tmp=$(mktemp -d)
    curl -fsSL -o "$tmp/chrome.deb" \
        https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y "$tmp/chrome.deb"
    rm -rf "$tmp"
fi

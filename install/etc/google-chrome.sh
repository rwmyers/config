#!/bin/zsh

# Google Chrome (https://www.google.com/chrome/).
# Linux-only, installed from Google's official apt repo rather than Nix: the
# Nix build's chrome-sandbox can't be setuid root in the read-only store, so
# it aborts under Ubuntu's unprivileged-userns restriction. The .deb installs
# chrome-sandbox as root:root 4755, which sandboxes correctly.
source $HOME/src/config/install/common.sh

[[ "$OSTYPE" == "linux-gnu"* ]] || exit 0

if [ ! -e "/usr/bin/google-chrome" ]
then
    print_note " -- Installing google-chrome"
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | \
        sudo gpg --dearmor --yes -o /etc/apt/keyrings/google-chrome-key.gpg
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome-key.gpg] https://dl.google.com/linux/chrome/deb/ stable main" | \
        sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null

    sudo apt update
    sudo apt install google-chrome-stable
fi

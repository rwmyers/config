#!/bin/zsh

# Antigravity, an editor by Google (https://antigravity.google/download/linux)
source $HOME/src/config/install/common.sh

if [ ! -e "/usr/bin/antigravity" ]
then
    print_note " -- Installing antigravity"
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \
        sudo gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg
    echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | \
        sudo tee /etc/apt/sources.list.d/antigravity.list > /dev/null

    sudo apt update
    sudo apt install antigravity
fi

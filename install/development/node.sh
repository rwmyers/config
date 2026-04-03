#!/bin/zsh

# Node.js via nvm (https://github.com/nvm-sh/nvm)
source $HOME/src/config/install/common.sh

export NVM_DIR="$HOME/.nvm"

if [ ! -d "$NVM_DIR" ]; then
    print_note "-- Installing nvm"
    NVM_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r '.tag_name')
    print_note "   Latest nvm version detected: $NVM_VERSION"
    if [[ -z "$NVM_VERSION" ]]; then
        echo "Error: Could not determine latest nvm version."
        exit 1
    fi
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash
fi

[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

print_note "-- Installing/updating to latest LTS Node.js"
nvm install --lts
nvm alias default lts/*

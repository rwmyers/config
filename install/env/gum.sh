#!/bin/zsh

# A tool for shell script input and output (https://github.com/charmbracelet/gum)
source $HOME/src/config/install/common.sh

if [ ! -e "/usr/bin/gum" ]
then
    print_note "Installing gum"
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
    sudo apt update && sudo apt install gum
fi

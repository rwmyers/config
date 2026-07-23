#!/bin/zsh

# Remove the cargo-installed impala. It drives iwd, but this fleet runs
# NetworkManager (with networkmanager-dmenu for Wi-Fi), so impala never worked
# here. Unconditional — no Nix gate. Delete this file once every machine is cleaned.
source $HOME/src/config/install/common.sh

if [ -e "$HOME/.cargo/bin/impala" ]
then
    print_note " -- Removing impala (needs iwd; this fleet uses NetworkManager)"
    rm -f "$HOME/.cargo/bin/impala"
fi

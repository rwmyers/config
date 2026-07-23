#!/bin/zsh

# Remove the cargo-installed bluetui now that it comes from Nix (nix/linux.nix).
# A leftover ~/.cargo/bin/bluetui could shadow the Nix one on PATH. Unconditional
# — no Nix gate. Delete this file once every machine is cleaned.
source $HOME/src/config/install/common.sh

if [ -e "$HOME/.cargo/bin/bluetui" ]
then
    print_note " -- Removing cargo-installed bluetui; it now comes from Nix"
    rm -f "$HOME/.cargo/bin/bluetui"
fi

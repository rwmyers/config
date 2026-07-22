#!/bin/zsh

# Remove the cargo-installed stylua now that Home Manager provides it. The repo
# .zshrc prepends ~/.cargo/bin ahead of ~/.nix-profile/bin, so the cargo copy
# would otherwise shadow the Nix one on PATH. Gated on the Nix stylua existing
# on disk. Delete this file once every machine has migrated.
source $HOME/src/config/install/common.sh

nix_stylua=""
for p in \
    "$HOME/.nix-profile/bin/stylua" \
    "$HOME/.local/state/nix/profiles/home-manager/home-path/bin/stylua"
do
    if [ -e "$p" ]
    then
        nix_stylua="$p"
        break
    fi
done

if [ -z "$nix_stylua" ]
then
    print_note "Skipping stylua cleanup; no Home Manager stylua found yet"
    exit 0
fi

if [ -e "$HOME/.cargo/bin/stylua" ]
then
    print_note "Removing cargo stylua (~/.cargo/bin/stylua); Nix provides it"
    rm "$HOME/.cargo/bin/stylua"
fi

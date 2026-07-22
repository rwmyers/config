#!/bin/zsh

# Remove the cargo-installed taplo now that Home Manager provides it. The repo
# .zshrc prepends ~/.cargo/bin ahead of ~/.nix-profile/bin, so the cargo copy
# would otherwise shadow the Nix one on PATH. Gated on the Nix taplo existing
# on disk. Delete this file once every machine has migrated.
source $HOME/src/config/install/common.sh

nix_taplo=""
for p in \
    "$HOME/.nix-profile/bin/taplo" \
    "$HOME/.local/state/nix/profiles/home-manager/home-path/bin/taplo"
do
    if [ -e "$p" ]
    then
        nix_taplo="$p"
        break
    fi
done

if [ -z "$nix_taplo" ]
then
    print_note "Skipping taplo cleanup; no Home Manager taplo found yet"
    exit 0
fi

if [ -e "$HOME/.cargo/bin/taplo" ]
then
    print_note "Removing cargo taplo (~/.cargo/bin/taplo); Nix provides it"
    rm "$HOME/.cargo/bin/taplo"
fi

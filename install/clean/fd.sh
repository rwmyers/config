#!/bin/zsh

# Remove the old fd -> fdfind shim now that Home Manager provides fd. Gated on
# the Nix fd existing on disk.
source $HOME/src/config/install/common.sh

nix_fd=""
for p in \
    "$HOME/.nix-profile/bin/fd" \
    "$HOME/.local/state/nix/profiles/home-manager/home-path/bin/fd"
do
    if [ -e "$p" ]
    then
        nix_fd="$p"
        break
    fi
done

if [ -z "$nix_fd" ]
then
    print_note "Skipping fd cleanup; no Home Manager fd found yet"
    exit 0
fi

if [ -L "$HOME/.local/bin/fd" ]
then
    print_note " -- Removing legacy fd shim (~/.local/bin/fd)"
    rm "$HOME/.local/bin/fd"
fi

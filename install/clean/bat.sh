#!/bin/zsh

# Remove the legacy bat shim now that Home Manager provides bat.
#
# install/development/bat.sh created ~/.local/bin/bat -> /usr/bin/batcat. Once
# Home Manager provides a real `bat`, that shim can shadow the Nix binary on
# PATH, so drop it. The ~/.config/bat config link is intentionally kept.
#
# The shim is only removed once a Nix-provided bat actually exists, so a machine
# that has not migrated yet (or a failed Nix install) is never left without bat.
# Delete this file once every machine has migrated.
source $HOME/src/config/install/common.sh

bat_shim="$HOME/.local/bin/bat"
nix_bat=""
for p in \
    "$HOME/.nix-profile/bin/bat" \
    "$HOME/.local/state/nix/profiles/home-manager/home-path/bin/bat"
do
    if [ -e "$p" ]
    then
        nix_bat="$p"
        break
    fi
done

if [ -L "$bat_shim" ]
then
    if [ -n "$nix_bat" ]
    then
        print_note " -- Removing legacy bat shim ($bat_shim); Nix provides bat"
        rm "$bat_shim"
    else
        print_note " -- Keeping bat shim; no Nix-provided bat found yet"
    fi
fi

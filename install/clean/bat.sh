#!/bin/zsh

# Remove pre-Nix bat artifacts now that Home Manager owns bat — binary, config,
# and themes (nix/programs/bat.nix).
#
# Both removals are gated on a Home Manager bat existing on disk, so a machine
# that hasn't migrated (or a failed install) is never left broken. This runs
# before nix.sh so the ~/.config/bat symlink is gone before Home Manager tries
# to manage that directory. Delete this file once every machine has migrated.
source $HOME/src/config/install/common.sh

# Is Home Manager's bat present on disk?
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

if [ -z "$nix_bat" ]
then
    print_note " -- Skipping bat cleanup; no Home Manager bat found yet"
    exit 0
fi

# 1. The old ~/.local/bin/bat -> batcat shim (created by the retired bat.sh).
if [ -L "$HOME/.local/bin/bat" ]
then
    print_note " -- Removing legacy bat shim (~/.local/bin/bat)"
    rm "$HOME/.local/bin/bat"
fi

# 2. The ~/.config/bat symlink into this repo, so Home Manager can manage that
#    directory (config + themes). Only remove if it points into the repo.
bat_cfg="$HOME/.config/bat"
if [ -L "$bat_cfg" ] && [[ "$(readlink "$bat_cfg")" == *"/src/config/.config/bat" ]]
then
    print_note " -- Removing repo bat config symlink (~/.config/bat); HM now owns it"
    rm "$bat_cfg"
fi

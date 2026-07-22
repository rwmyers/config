#!/bin/zsh

# Remove pre-Nix bat artifacts now that Home Manager owns bat. Runs before nix.sh.
source $HOME/src/config/install/common.sh

# Repo config symlink: remove before HM activates so HM can own the dir. Not
# gated on a Nix bat (doesn't exist yet on first activation). HM recreates it.
bat_cfg="$HOME/.config/bat"
if [ -L "$bat_cfg" ] && [[ "$(readlink "$bat_cfg")" == *"/src/config/.config/bat" ]]
then
    print_note " -- Removing repo bat config symlink (~/.config/bat)"
    rm "$bat_cfg"
fi

# batcat shim: gated on a Nix bat existing, so we never leave the machine bat-less.
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

if [ -n "$nix_bat" ] && [ -L "$HOME/.local/bin/bat" ]
then
    print_note " -- Removing legacy bat shim (~/.local/bin/bat)"
    rm "$HOME/.local/bin/bat"
fi

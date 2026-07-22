#!/bin/zsh

# Remove the pre-Nix fzf clone now that Home Manager provides fzf. Gated on the
# Nix fzf existing on disk.
source $HOME/src/config/install/common.sh

nix_fzf=""
for p in \
    "$HOME/.nix-profile/bin/fzf" \
    "$HOME/.local/state/nix/profiles/home-manager/home-path/bin/fzf"
do
    if [ -e "$p" ]
    then
        nix_fzf="$p"
        break
    fi
done

if [ -z "$nix_fzf" ]
then
    print_note "Skipping fzf cleanup; no Home Manager fzf found yet"
    exit 0
fi

if [ -d "$HOME/.fzf" ] || [ -e "$HOME/.fzf.zsh" ]
then
    print_note " -- Removing pre-Nix fzf clone (~/.fzf, ~/.fzf.zsh)"
    rm -rf "$HOME/.fzf" "$HOME/.fzf.zsh"
fi

#!/bin/zsh

# Remove the pre-Nix fzf-git clone now that Home Manager provides it. Gated on
# the Nix fzf-git script existing on disk.
source $HOME/src/config/install/common.sh

nix_fzf_git=""
for p in \
    "$HOME/.nix-profile/share/fzf-git-sh/fzf-git.sh" \
    "$HOME/.local/state/nix/profiles/home-manager/home-path/share/fzf-git-sh/fzf-git.sh"
do
    if [ -e "$p" ]
    then
        nix_fzf_git="$p"
        break
    fi
done

if [ -z "$nix_fzf_git" ]
then
    print_note "Skipping fzf-git cleanup; no Home Manager fzf-git found yet"
    exit 0
fi

if [ -d "$HOME/src/fzf-git.sh" ]
then
    print_note " -- Removing pre-Nix fzf-git clone (~/src/fzf-git.sh)"
    rm -rf "$HOME/src/fzf-git.sh"
fi

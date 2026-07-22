#!/bin/zsh

# Remove the pre-Nix fzf-tab clone now that Home Manager provides it. Gated on
# the Nix fzf-tab plugin existing on disk.
source $HOME/src/config/install/common.sh

nix_fzf_tab=""
for p in \
    "$HOME/.nix-profile/share/fzf-tab/fzf-tab.plugin.zsh" \
    "$HOME/.local/state/nix/profiles/home-manager/home-path/share/fzf-tab/fzf-tab.plugin.zsh"
do
    if [ -e "$p" ]
    then
        nix_fzf_tab="$p"
        break
    fi
done

if [ -z "$nix_fzf_tab" ]
then
    print_note "Skipping fzf-tab cleanup; no Home Manager fzf-tab found yet"
    exit 0
fi

if [ -d "$HOME/src/fzf-tab" ]
then
    print_note " -- Removing pre-Nix fzf-tab clone (~/src/fzf-tab)"
    rm -rf "$HOME/src/fzf-tab"
fi

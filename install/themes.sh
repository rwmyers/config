#!/bin/zsh

source install/common.sh

print_note "Installing themes"

ln -snf $SRC_ROOT/themes $HOME/themes

# themes/current is per-device, so stop git tracking changes to it here
git -C $SRC_ROOT update-index --skip-worktree themes/current

# btop theme linkage
mkdir -p $HOME/.config/btop/themes
ln -snf $HOME/themes/current/btop.theme $HOME/.config/btop/themes/current.theme

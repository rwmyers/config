#!/bin/zsh

# Antigravity 2.0 by Google (https://antigravity.google). Installed with
# Google's bootstrapper, which drops the `agy` binary in ~/.local/bin and works
# the same on Linux and macOS — so this is no longer Linux-only. Optional;
# enable via `dot config`.
source $HOME/src/config/install/common.sh

feature_enabled antigravity || exit 0

AGY="$HOME/.local/bin/agy"

# The bootstrapper is a no-op once the binary exists (agy self-updates in the
# background), but skip the download entirely when there's nothing to do.
if [ -x "$AGY" ] || type agy > /dev/null 2>&1
then
    exit 0
fi

print_note " -- Installing antigravity"
curl -fsSL https://antigravity.google/cli/install.sh | bash

# The bootstrapper hands off to `agy install`, which edits shell rc files. Ours
# is a symlink into this repo and already has ~/.local/bin on PATH, so say
# something rather than letting setup silently dirty the working tree.
if ! git -C "$SRC_ROOT" diff --quiet -- .zshrc
then
    print_error "antigravity's installer modified $SRC_ROOT/.zshrc; review and revert if unwanted."
fi

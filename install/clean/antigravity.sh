#!/bin/zsh

# Antigravity used to come from Google's apt repo; 2.0 is installed by the
# bootstrapper in install/development/antigravity.sh instead. Drop the repo
# definition and its keyring so apt stops pulling from a channel we no longer
# manage. Any package already installed from it is left alone — remove it with
# `sudo apt remove antigravity` if you don't want the old editor around.
source $HOME/src/config/install/common.sh

[[ "$OSTYPE" == "linux-gnu"* ]] || exit 0

if [ -e /etc/apt/sources.list.d/antigravity.list ]
then
    print_note " -- Removing superseded antigravity apt repo"
    sudo rm -f /etc/apt/sources.list.d/antigravity.list \
        /etc/apt/keyrings/antigravity-repo-key.gpg
fi

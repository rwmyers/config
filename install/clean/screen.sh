#!/bin/zsh

# Remove the retired ~/.screenrc link now that screen/ is gone from the repo.
# Only touches symlinks, so a hand-written .screenrc is left alone.
# Delete this file once every machine has been cleaned.
source $HOME/src/config/install/common.sh

if [ -L "$HOME/.screenrc" ]
then
    print_note " -- Removing retired screen config (~/.screenrc)"
    rm -f "$HOME/.screenrc"
fi

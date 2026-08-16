#!/bin/zsh

source install/common.sh

print_note "Linking items"

# Nothing else puts Nix on a new shell's PATH, so a ~/.zshrc that isn't ours
# silently breaks the rest of setup. Say so rather than skipping quietly.
if [ ! -e "$HOME/.zshrc" ]
then
    ln -s ~/src/config/.zshrc ~/.zshrc
elif [ ! -L "$HOME/.zshrc" ]
then
    print_error "~/.zshrc exists and isn't our symlink; move it aside and re-run setup."
fi

if [ ! -f "$HOME/.zshrc.local" ]
then
    touch ~/.zshrc.local
fi

if [ ! -d "$HOME/.config/zsh" ]
then
    print_note "Creating .config/zsh link"
    ln -s ~/src/config/.config/zsh ~/.config/zsh
fi

if [ ! -d "$HOME/.aliases" ]
then
    print_note "Creating .aliases"
    ln -s ~/src/config/.aliases ~/.aliases
fi

if [ ! -d "$HOME/.aliases.local" ]
then
    print_note "Creating .aliases.local"
    mkdir -p $HOME/.aliases.local
fi

if [ ! -d "$HOME/.completions" ]
then
    print_note "Creating .completions"
    ln -s ~/src/config/.completions/ ~/.completions
fi

if [ ! -d "$HOME/.functions" ]
then
    print_note "Creating .functions"
    ln -s ~/src/config/.functions ~/.functions
fi

if [ ! -d "$HOME/.functions.local" ]
then
    print_note "Creating .functions.local"
    mkdir -p $HOME/.functions.local
fi

if [ ! -f "$HOME/.gitconfig" ]
then
    ln -s ~/src/config/git/.gitconfig ~/.gitconfig
fi

if [ ! -f "$HOME/.gitignore_global" ]
then
    ln -s ~/src/config/git/.gitignore_global ~/.gitignore_global
fi

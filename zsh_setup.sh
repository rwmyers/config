#!/bin/zsh
NOTE='\033[1;32m'
NC='\033[0m'

if [ ! -d "$HOME/.oh-my-zsh" ]
then
    pushd ~/ > /dev/null
    git clone git@github.com:ohmyzsh/ohmyzsh.git .oh-my-zsh
    popd
else
    pushd ~/.oh-my-zsh
    git pull
    popd
fi

if [ ! -d "$HOME/.oh-my-zsh/themes/powerlevel10k" ]
then
    pushd ~/.oh-my-zsh/themes
    git clone https://github.com/romkatv/powerlevel10k.git
    popd
else
    pushd ~/.oh-my-zsh/themes/powerlevel10k
    git pull
    popd
fi

if [ ! -f "$HOME/.zshrc" ]
then
    ln -s ~/src/config/.zshrc ~/.zshrc
fi

if [ ! -f "$HOME/.zshrc.local" ]
then
    touch ~/.zshrc.local
fi

if [ ! -d "$HOME/.aliases" ]
then
    ln -s ~/src/config/.aliases ~/.aliases
fi

if [ ! -f "$HOME/.gitconfig" ]
then
    ln -s ~/src/config/.gitconfig ~/.gitconfig
fi

if [ ! -f "$HOME/.gitignore_global" ]
then
    ln -s ~/src/config/.gitignore_global ~/.gitignore_global
fi

if ! type "tmux" > /dev/null;
then
    if [[ "$OSTYPE" == "darwin"* ]];
    then
        brew update
        brew install tmux
    fi
fi

if [ ! -f "$HOME/.tmux.conf" ]
then
    ln -s ~/src/config/.tmux.conf ~/.tmux.conf
fi

if [ ! -f "$HOME/.tmux.conf.local" ]
then
    ln -s ~/src/config/.tmux.conf.local ~/.tmux.conf.local
fi

if [ ! -f "$HOME/tmux-cheatsheet" ]
then
    ln -s ~/src/config/tmux-cheatsheet ~/tmux-cheatsheet
fi


if [ ! -f "$HOME/.vimrc" ]
then
    ln -s ~/src/config/.vimrc ~/.vimrc
fi

if [ ! -d "$HOME/.vim" ]
then
    ln -s ~/src/config/.vim ~/.vim
fi

if [ ! -d "$HOME/.p10k.zsh" ]
then
    ln -s ~/src/config/.p10k.zsh ~/.p10k.zsh
    printf "${NOTE}IMPORTANT: Make sure to install the powerline font in the ~$HOME/src/config/fonts directory${NC}\n"
fi


if [ ! -d "$HOME/.config/alacritty" ]
then
    mkdir -p ~/.config/alacritty
    ln -s ~/src/config/.config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
fi

if [[ "$OSTYPE" == "darwin"* ]];
then
    for file in ~/src/config/fonts/**/*(.); do
        cp $file /Library/Fonts/
    done
fi

if [[ "$OSTYPE" == "darwin"* ]];
then
    brew install coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt grep
fi

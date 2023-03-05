#!/bin/zsh
NOTE='\033[1;32m'
NC='\033[0m'
SRC_ROOT="$HOME/src/config"

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

if [ ! -d "$HOME/.functions" ]
then
    ln -s ~/src/config/.functions ~/.functions
fi

if [ ! -f "$HOME/.gitconfig" ]
then
    ln -s ~/src/config/git/.gitconfig ~/.gitconfig
fi

if [ ! -f "$HOME/.gitignore_global" ]
then
    ln -s ~/src/config/git/.gitignore_global ~/.gitignore_global
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
if [[ "$OSTYPE" == "linux-gnu"* ]];
then
    if ! type "vim" > /dev/null;
    then
        sudo apt -y install vim
    fi
fi


if [ ! -f "$HOME/.p10k.zsh" ]
then
    ln -s ~/src/config/.p10k.zsh ~/.p10k.zsh
fi

if [ ! -d "$HOME/src/fonts/" ]
then
    mkdir -p ~/src/fonts/
    cp ~/src/config/fonts/* ~/src/fonts
    pushd ~/src/fonts/
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
    popd
    if [[ "$OSTYPE" == "darwin"* ]];
    then
        for file in ~/src/fonts//**/*(.); do
            cp $file /Library/Fonts/
        done
    else
        mkdir -p $HOME/.fonts
        for file in ~/src/fonts//**/*(.); do
            cp $file $HOME/.fonts/
        done
    fi
    printf "${NOTE}IMPORTANT: Set fonts the ~$HOME/src/fonts/${NC}\n"
    printf "${NOTE}MesloLGS NF:${NC} For nerd fonts / terminal usage\n"
    printf "${NOTE}Pull Cascadia Code here: https://github.com/microsoft/cascadia-code/releases${NC}\n"
fi

if [ ! -d "$HOME/.config/alacritty" ]
then
    mkdir -p ~/.config/alacritty
    ln -s ~/src/config/.config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
fi

if [[ "$OSTYPE" == "darwin"* ]];
then
    brew install coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt grep
fi

if ! type "cloc" > /dev/null;
then
    echo "cloc not installed."
    if [[ "$OSTYPE" == "darwin"* ]];
    then
        echo "Installing cloc on OSX"
        brew install cloc
    elif [[ -n "$(command -v yum)" ]]
    then
        echo "Installing cloc using yum"
        sudo yum install cloc
    else
        echo "Installing cloc on Linux"
        sudo apt -y install cloc
    fi
fi

if [ ! -d "$HOME/bin" ]
then
    ln -s ~/src/config/bin ~/bin
fi

if [ ! -d "$HOME/bin.local" ]
then
    mkdir -p ~/bin.local
fi

if [ ! -f "$HOME/.config/i3/config" ]
then
    mkdir -p ~/.config/i3
    ln -s $SRC_ROOT/.config/i3/config ~/.config/i3/config
fi

if [ ! -f "$HOME/.config/i3/config.local" ]
then
    cp $SRC_ROOT/.config/i3/config.local ~/.config/i3/config.local
fi


if [[ "$OSTYPE" == "linux-gnu"* ]];
then
    if ! type "playerctl" > /dev/null;
    then
        sudo apt -y install playerctl
    fi
    if ! type "polybar" > /dev/null;
    then;
        sudo apt -y install polybar
    fi
    if ! type "xclip" > /dev/null;
    then
        sudo apt -y install xclip
    fi
    if ! type "blueman-manager" > /dev/null;
    then
        sudo apt -y install blueman
    fi
    if ! type "rofi" > /dev/null;
    then
        sudo apt -y install rofi
    fi
    if ! type "maim" > /dev/null;
    then
        sudo apt -y install maim
    fi
fi

if [ ! -e "$HOME/.config/polybar" ]
then
    ln -s $SRC_ROOT/.config/polybar/ ~/.config/polybar
fi

if [ ! -e "$HOME/.config/kmonad" ]
then
    ln -s $SRC_ROOT/.config/kmonad/ ~/.config/kmonad
fi

if [ ! -e "$HOME/.config/systemd" ]
then
    ln -s $SRC_ROOT/.config/systemd/ ~/.config/systemd
fi

if [ ! -e "$HOME/.config/rofi" ]
then
    ln -s $SRC_ROOT/.config/rofi/ ~/.config/rofi
fi

if [ ! -d "$HOME/src/i3-projects" ]
then
    pushd ~/src/
    git clone git@github.com:Mezner/i3-projects.git
    popd

    ln -s ~/src/i3-projects/project-save ~/bin/project-save
    ln -s ~/src/i3-projects/template.txt ~/bin/template.txt
else
    pushd ~/src/i3-projects
    git pull
    popd
fi

if [ ! -e "$HOME/bin/project-save" ]
then
    ln -s $SRC_ROOT/i3-projects/project-save ~/bin/project-save
fi

if [ ! -e "$HOME/bin/template.txt" ]
then
    ln -s $SRC_ROOT/i3-projects/template.txt ~/bin/template.txt
fi


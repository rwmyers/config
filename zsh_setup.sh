#!/bin/zsh
NOTE='\033[1;32m'
NC='\033[0m'
SRC_ROOT="$HOME/src/config"

print_note()
{
    printf "${NOTE}$1${NC}\n"
}

install_linux_package()
{
    local check="$1"
    # Use the check as package if not provided.
    local pkg="${2:-$check}"
    # Use the package if there is not an arch package.
    local arch_pkg="${3:-$pkg}"

    if [[ "$OSTYPE" == "linux-gnu"* ]];
    then
        if ! type "${check}" > /dev/null;
        then
            print_note "Installing ${pkg}"
	        if [ -f "/etc/arch-release" ]
            then
		        sudo pamac install ${arch_pkg}
	        else
                sudo apt -y install ${pkg}
	        fi
        fi
    fi
}

install_snap()
{
    if [[ "$OSTYPE" == "linux-gnu"* ]];
    then
        if ! type "$1" > /dev/null;
        then
            print_note "Installing $1"
            sudo snap install $1
        fi
    fi
}

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

if [[ "$OSTYPE" == "linux-gnu"* ]];
then

    if [ -f "/etc/arch-release" ]
    then
	    print_note "pamac update"
	    sudo pamac update && sudo apt upgrade
	    sudo pamac install ${arch_pkg}
    else
	    print_note "apt update"
	    sudo apt -y install ${pkg}
    fi
    print_note "snap update"
    sudo snap refresh

    install_linux_package vim
    install_linux_package nvim neovim
    install_linux_package sway
    install_linux_package swayidle
    install_linux_package wofi
    install_linux_package swaylock
    install_linux_package wl-copy wl-clipboard
    install_linux_package slurp
    install_linux_package grim
    install_linux_package curl
    install_linux_package thunar
    install_linux_package alacritty
    install_linux_package fdfind fd-find
    install_linux_package delta git-delta
    install_linux_package batcat bat
    install_linux_package pavucontrol
    install_linux_package pulseaudio

    if ! type "z" > /dev/null;
    then
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    fi

    ## fd-find link
    if ! type "fd" > /dev/null;
    then
        ln -s $(which fdfind) ~/.local/bin/fd
    fi

    ## bat link from batcat
    if ! type "bat" > /dev/null;
    then
        ln -s $(which batcat) ~/.local/bin/bat
    fi

    ## eza, a better ls (github.com/eza-community/eza)
    # this can't yet be installed from apt directly
    if ! type "eza" > /dev/null;
    then
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
        sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
        sudo apt update
        sudo apt install -y eza
    fi

    install_snap discord

    if ! type "wdisplays" > /dev/null;
    then
        sudo apt -y install wdisplays
    fi

    if ! type "waybar" > /dev/null;
    then
        sudo apt -y install waybar
    fi

    if ! type "kmonad" > /dev/null;
    then
        # install stack, which is a dependency to build kmonad
        curl -sSL https://get.haskellstack.org/ | sh

        # pull kmonad and build it
        pushd $HOME/src/
        git clone https://github.com/kmonad/kmonad.git
        pushd kmonad
        stack install
        popd
        popd

        # add the uinput mod and give permissions to your user
        sudo modprobe uinput
        sudo groupadd uinput
        sudo usermod -aG input $USER
        sudo usermod -aG uinput $USER

        echo "Adding udev kmonad rules"
        echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee -a /etc/udev/rules.d/40-kmonad.rules > /dev/null
    fi

    KMONAD_SERVICE="kmonad.service"
    systemctl --user status $KMONAD_SERVICE &> /dev/null
    if [ $? != 0 ]; then
        print_note "Creating $KMONAD_SERVICE"
        systemctl --user start $KMONAD_SERVICE
        systemctl --user enable $KMONAD_SERVICE
    fi
fi

if ! type "tmux" > /dev/null;
then
    echo "Installing tmux..."
    if [[ "$OSTYPE" == "darwin"* ]];
    then
        brew update
        brew install tmux
    fi

    if [[ "$OSTYPE" == "linux-gnu"* ]];
    then
        sudo apt -y install tmux
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

# neovim dot files
# re-use from vim
if [ ! -d "$HOME/.config/nvim" ]
then
    ln -s ~/src/config/.vim ~/.config/nvim
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

if [ ! -f "$HOME/.config/alacritty/alacritty.toml" ]
then
    mkdir -p ~/.config/alacritty
    ln -s ~/src/config/.config/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
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

if ! type "fzf" > /dev/null;
then
    print_note "Installing fzf"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi

if [ ! -d "$HOME/src/fzf-git.sh" ]
then
    print_note "Installing fzf-git"
    pushd ~/src/
    git clone https://github.com/junegunn/fzf-git.sh.git
    popd
else
    pushd ~/src/fzf-git.sh
    git pull
    popd
fi


if [ ! -d "$HOME/bin" ]
then
    ln -s ~/src/config/bin ~/bin
fi

if [ ! -d "$HOME/bin.local" ]
then
    mkdir -p ~/bin.local
fi

if [ ! -f "$HOME/.config/sway/config" ]
then
    mkdir -p ~/.config/sway
    ln -s $SRC_ROOT/.config/sway/config ~/.config/sway/config
fi

if [ ! -f "$HOME/.config/sway/config.local" ]
then
    cp $SRC_ROOT/.config/sway/config.local ~/.config/sway/config.local
fi

if [ ! -d "$HOME/.config/sway/scripts" ]
then
    print_note "Creating sway scripts link..."
    ln -s $SRC_ROOT/.config/sway/scripts $HOME/.config/sway/scripts
fi

if [ ! -d "$HOME/.config/sway/modes" ]
then
    print_note "Creating sway modes link..."
    ln -s $SRC_ROOT/.config/sway/modes $HOME/.config/sway/modes
fi

if [ ! -f "$HOME/.config/sway/display_mode" ]
then
    print_note "Adding display_mode sway link"
    ln -s $SRC_ROOT/.config/sway/display_mode ~/.config/sway/display_mode
fi

if [ ! -f "$HOME/.config/sway/default.mode" ]
then
    print_note "Copying a default.mode over for use."
    cp $SRC_ROOT/.config/sway/default.mode ~/.config/sway/default.mode
fi

if [ ! -f "$HOME/.config/waybar/config" ]
then
    echo "Creating waybar config links..."
    mkdir -p ~/.config/waybar
    ln -s $SRC_ROOT/.config/waybar/config ~/.config/waybar/config
    ln -s $SRC_ROOT/.config/waybar/style.css ~/.config/waybar/style.css

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
    if ! type "blueman-manager" > /dev/null;
    then
        sudo apt -y install blueman
    fi
    if ! type "pip" > /dev/null;
    then
        sudo apt -y install pip
    fi
fi

if [ $(pip list | grep jq | wc -c) -eq 0 ]
then
    pip install jq
fi

if [ $(pip list | grep -i jinja | wc -c) -eq 0 ]
then
    pip install jinja2
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

if [ ! -e "$HOME/.config/wofi" ]
then
    ln -s $SRC_ROOT/.config/wofi/ ~/.config/wofi
fi

## KDE Config
if [ ! -e "$HOME/.config/kglobalshortcutsrc" ]
then
    ln -s $SRC_ROOT/.config/kglobalshortcutsrc ~/.config/kglobalshortcutsrc
fi

# VS Code user settings
if [ ! -e "$HOME/.config/Code/User/keybindings.json" ]
then
    print_note "Adding VSCode user settings"
    mkdir -p $HOME/.config/Code/User
    ln -s $SRC_ROOT/.config/Code/User/keybindings.json ~/.config/Code/User/keybindings.json
    ln -s $SRC_ROOT/.config/Code/User/settings.json ~/.config/Code/User/settings.json
fi

# Starship install
if ! type "starship" > /dev/null;
then
    print_note "Installing starship"
    if [[ "$OSTYPE" == "linux-gnu"* ]];
    then
        curl -sS https://starship.rs/install.sh | sh
    fi
    if [[ "$OSTYPE" == "darwin"* ]];
    then
        brew update
        brew install starship
    fi
fi

# Starship configuration
if [ ! -d "$HOME/.config/starship/" ]
then
    print_note "Adding starship configuration"
    ln -s $SRC_ROOT/.config/starship/ ~/.config/starship
fi

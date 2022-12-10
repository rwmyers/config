#/bin/bash

if [[ "$OSTYPE" == "darwin"* ]];
then
    if ! type brew > /dev/null;
    then
        echo "Installing Brew on OSX"
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        echo "Updating brew"
        brew update
    fi
fi

if ! type "zsh" > /dev/null; 
then
    echo "Zsh not installed."
    if [[ "$OSTYPE" == "darwin"* ]];
    then
        echo "Installing zsh on OSX"
        brew install zsh
        echo "Manually set your default shell to /bin/zsh"
        exit 1
    elif [-n "$(command -v yum)"]
    then
        echo "Installing zsh with yum"
        sudo yum install zsh
        echo "Changing default shell"$
        chsh --shell /usr/bin/zsh
    else
        echo "Installing zsh on Linux"
        sudo apt-get -y install zsh
        echo "Changing default shell"
        chsh --shell /usr/bin/zsh 
    fi
fi

if ! type "git" > /dev/null; 
then
    echo "git not installed."
    if [[ "$OSTYPE" == "darwin"* ]];
    then
        echo "Manually install git and re-run script"
        exit 1
    else
        echo "Installing git on Debian-based Linux"
        sudo apt-get -y install git
    fi
fi

if [ ! -d "$HOME/src/" ] 
then
    mkdir -p ~/src/
fi

if ! cat ~/.ssh/id_rsa.pub > /dev/null; 
then
    echo "No keyfile detected. Running SSH-keygen"
    ssh-keygen
    echo ""
    cat ~/.ssh/id_rsa.pub
    echo ""
    read -p "Put the token in github ( https://github.com/settings/ssh/new ) and press any key to continue"
fi

if [ ! -d "$HOME/src/config" ]
then
    pushd ~/src > /dev/null
    git clone git@github.com:Mezner/config.git
    popd > /dev/null
else
    pushd ~/src/config > /dev/null
    git pull
    popd > /dev/null
fi

pushd ~/src/config
zsh zsh_setup.sh

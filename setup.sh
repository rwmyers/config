#!/bin/sh
mkdir ~/src
cd ~/src
echo 'installing applications'
sudo apt-get install git
sudo apt-get install zsh
sudo chsh /bin/zsh
cat ~/.ssh/id_rsa.pub
read -p "Put the token in github and press any key to continue"
echo 'pulling configurations'
git clone git@github.com:Mezner/Personal-Configurations.git configs
cd ~/src/configs
cp .zshrc ~/
cd ~
git clone git@github.com:Mezner/oh-my-zsh.git.oh-my-zsh
mkdir ~/bin
echo 'git config'
cp git/.git* ~/
echo 'vim config'
cp -rf vim/.vim* ~/
echo 'bash config'
cp -rf bash/.bash* ~/
ssh-keygen -N ""

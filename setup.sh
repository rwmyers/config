#!/bin/sh
mkdir ~/src
cd ~/src
echo 'installing applications'
sudo apt-get install git
sudo apt-get install zsh
sudo chsh /bin/zsh
echo 'pulling configurations'
git clone https://github.com/Mezner/Personal-Configurations.git configs
cd ~/src/configs
cp .zshrc ~/
cd ~
git clone https://github.com/Mezner/oh-my-zsh.git .oh-my-zsh
mkdir ~/bin
echo 'git config'
cp git/.git* ~/
echo 'vim config'
cp -rf vim/.vim* ~/
echo 'bash config'
cp -rf bash/.bash* ~/
ssh-keygen -N ""
cat ~/.ssh/id_rsa.pub
echo 'USE THE ABOVE IN GIT HOSTS!'

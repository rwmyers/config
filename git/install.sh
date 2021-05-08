#!/bin/zsh
git clone https://github.com/Mezner/gitscripts.git
echo "# git scripts" >> ~/.zshrc
echo "# git scripts" >> ~/.bashrc
echo "export \"PATH=\$PATH:$(pwd)/gitscripts/\"" >> ~/.zshrc
echo "export \"PATH=\$PATH:$(pwd)/gitscripts/\"" >> ~/.bashrc

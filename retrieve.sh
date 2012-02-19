#!/bin/bash
# Script to pull the current user configuration into the current directory.

# Git-related files
cp -v ~/.gitignore_global .
cp -v ~/.gitconfig .

# Screen configuration
cp -v ~/.screenrc .

cp -v ~/.inputrc .
cp -v ~/.vimrc .
cp -v ~/.bash_profile .

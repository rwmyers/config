#!/bin/zsh

source install/common.sh

print_note "Installing misc. items"

for f in install/etc/*; do $f; done

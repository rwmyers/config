#!/bin/zsh

source install/common.sh

print_note "Installing environment items"

for f in install/env/*; do $f; done

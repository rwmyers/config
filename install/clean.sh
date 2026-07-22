#!/bin/zsh

source install/common.sh

print_note "Cleaning up artifacts superseded by Nix"

for f in install/clean/*; do $f; done

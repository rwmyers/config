#!/bin/zsh

source install/common.sh

print_note "Installing package management tools"

for f in install/pkg_mgmt/*; do $f; done

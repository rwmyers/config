#!/bin/zsh

source install/common.sh

print_note "Installing development tools"

# Rust
if ! type "cargo" > /dev/null;
then
    print_note "Installing rust / cargo"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

if ! type "rust-analyzer" > /dev/null;
then
    print_note "Installing rust-analyzer"
    rustup component add rust-analyzer
fi

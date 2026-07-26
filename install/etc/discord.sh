#!/bin/zsh

# Discord (https://discord.com/). Optional - toggle the `discord` feature via
# `dot config`. Flathub rather than Nix: the Nix build's Chromium sandbox
# needs unprivileged user namespaces, which Ubuntu restricts.
source $HOME/src/config/install/common.sh

[[ "$OSTYPE" == "linux-gnu"* ]] || exit 0
feature_enabled discord || exit 0

flatpak_install com.discordapp.Discord

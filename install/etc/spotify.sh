#!/bin/zsh

# Spotify (https://spotify.com/). Optional - toggle the `spotify` feature via
# `dot config`. Flathub rather than Nix: the Nix build's CEF sandbox needs
# unprivileged user namespaces, which Ubuntu restricts.
source $HOME/src/config/install/common.sh

[[ "$OSTYPE" == "linux-gnu"* ]] || exit 0
feature_enabled spotify || exit 0

flatpak_install com.spotify.Client

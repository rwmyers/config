#!/bin/zsh

# Steam (https://store.steampowered.com/). Optional - toggle the `steam`
# feature via `dot config`.
# Linux-only, installed from Valve's .deb rather than Nix: the Nix build wraps
# Steam in a bubblewrap FHS env, and unprivileged bwrap can't create user
# namespaces under Ubuntu's userns restriction (no AppArmor profile covers the
# Nix store path), so it dies before Steam even starts. The .deb runs natively
# and self-configures Valve's apt repo for future launcher updates.
source $HOME/src/config/install/common.sh

[[ "$OSTYPE" == "linux-gnu"* ]] || exit 0

# Toggling the feature off just skips the install; it doesn't uninstall an
# existing Steam, since the launcher is harmless without the library and
# removing it risks a user's game data workflow.
feature_enabled steam || exit 0

if [ ! -e "/usr/bin/steam" ]
then
    print_note " -- Installing steam"
    tmp=$(mktemp -d)
    curl -fsSL -o "$tmp/steam.deb" \
        https://repo.steampowered.com/steam/archive/stable/steam_latest.deb
    sudo apt install -y "$tmp/steam.deb"
    rm -rf "$tmp"
fi

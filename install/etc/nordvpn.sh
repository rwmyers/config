#!/bin/zsh

# NordVPN (https://nordvpn.com/). Optional - toggle the `nordvpn` feature via
# `dot config`. Snap rather than Nix: the client isn't packaged in nixpkgs.
source $HOME/src/config/install/common.sh

[[ "$OSTYPE" == "linux-gnu"* ]] || exit 0

# Toggling the feature off just skips the install; it doesn't uninstall an
# existing NordVPN, since removing it would drop the machine's VPN config.
feature_enabled nordvpn || exit 0

if ! snap list nordvpn > /dev/null 2>&1
then
    print_note " -- Installing nordvpn"
    sudo snap install nordvpn
fi

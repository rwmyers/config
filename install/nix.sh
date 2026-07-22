#!/bin/zsh

# Cross-platform package layer: install Nix if needed, then activate the Home
# Manager flake at nix/. See nix/ for details.
#
# Exit code 90 signals zsh_setup.sh to halt. It fires whenever the calling shell
# does not already have Nix on PATH: in that case downstream setup steps won't
# have the Home Manager profile either, so setup must be re-run from a new shell
# (one that sources Nix via .zshrc) to finish.
source $HOME/src/config/install/common.sh

# Did the calling shell already have Nix on PATH? Capture before we touch PATH.
if type nix > /dev/null 2>&1
then
    nix_inherited=1
else
    nix_inherited=0
fi

if [ ! -d /nix ]
then
    print_note "Installing Nix"
    # --no-modify-profile: don't touch /etc shell rc; PATH is set up in .zshrc.
    curl --proto '=https' --tlsv1.2 -sSf -L \
        https://install.determinate.systems/nix | sh -s -- install --no-confirm --no-modify-profile
fi

# Bring nix onto PATH for this script's own use.
if ! type nix > /dev/null 2>&1 && \
   [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]
then
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

if ! type nix > /dev/null 2>&1
then
    print_error "Nix is installed but not usable in this shell. Open a new shell and re-run setup."
    exit 90
fi

# Enable flakes / nix-command for ALL nix invocations, including the nested ones
# Home Manager makes during activation (the outer --extra-experimental-features
# flag below doesn't propagate to those). User-level, no sudo, portable — matters
# on machines whose system nix.conf doesn't already enable it.
nix_conf="$HOME/.config/nix/nix.conf"
if ! grep -qs 'experimental-features.*flakes' "$nix_conf"
then
    print_note "Enabling nix-command + flakes in $nix_conf"
    mkdir -p "$(dirname "$nix_conf")"
    echo "experimental-features = nix-command flakes" >> "$nix_conf"
fi

# If the Nix daemon is unreachable because a nix-users group gates the socket
# directory, add us to it. Group changes only apply to new sessions, so this
# halts with a re-login instruction. Only fires when the daemon is actually
# unreachable, so healthy machines skip it.
if ! nix --extra-experimental-features 'nix-command' store ping > /dev/null 2>&1
then
    if getent group nix-users > /dev/null 2>&1
    then
        if ! getent group nix-users | grep -qw "$USER"
        then
            print_note "Nix daemon unreachable; adding $USER to the nix-users group"
            sudo usermod -aG nix-users "$USER"
        fi
        print_note "nix-users not active in this session. Log out/in (or run 'newgrp nix-users'), then re-run setup."
    else
        print_error "Nix daemon unreachable (see error above). Resolve and re-run setup."
    fi
    exit 90
fi

# Activate the Home Manager flake. --impure lets the flake read USER/HOME so the
# same config works for any user; -b backup renames conflicting existing files.
print_note "Activating Home Manager"
if ! nix --extra-experimental-features 'nix-command flakes' run home-manager/master -- \
    switch -b backup --impure --flake "$SRC_ROOT/nix#default"
then
    print_error "Home Manager activation failed (see the error above). Fix it and re-run setup."
    exit 90
fi

# If the calling shell didn't already have Nix, downstream setup steps won't see
# the Home Manager profile on PATH. It's activated now, so re-running from a
# fresh shell (which sources Nix via .zshrc) will complete cleanly.
if [ $nix_inherited -eq 0 ]
then
    print_note "Nix profile isn't on this shell's PATH yet. Open a new shell and re-run setup to finish."
    exit 90
fi

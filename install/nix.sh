#!/bin/zsh

# Cross-platform package layer: install Nix if needed, then activate the Home
# Manager flake at nix/. See nix/ for details.
#
# Exit code 90 signals zsh_setup.sh to halt. It is reserved for things the user
# has to resolve out-of-band (an unreachable daemon, a failed activation) — never
# for "Nix isn't on this shell's PATH", which setup fixes for itself via
# source_nix_env.
source $HOME/src/config/install/common.sh

# --upgrade refreshes nix/flake.lock to the latest upstream inputs before
# activating; by default the pinned lock is used. Remaining arguments name
# specific inputs to update (e.g. nixpkgs); with none, all inputs move.
upgrade=0
if [ "$1" = "--upgrade" ]
then
    upgrade=1
    shift
fi

if [ ! -d /nix ]
then
    print_note "Installing Nix"
    # --no-modify-profile: don't touch /etc shell rc; PATH is set up in .zshrc.
    curl --proto '=https' --tlsv1.2 -sSf -L \
        https://install.determinate.systems/nix | sh -s -- install --no-confirm --no-modify-profile
fi

# Bring nix onto PATH for this script's own use (a freshly installed Nix is
# never on the calling shell's PATH).
if ! source_nix_env
then
    print_error "Nix is installed but no usable profile script was found under /nix. Resolve and re-run setup."
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

# Move the lock forward when asked. Kept separate from activation so a failed
# fetch leaves the working lock in place rather than a half-updated one.
if [ $upgrade -eq 1 ]
then
    print_note "Updating nix/flake.lock"
    if ! nix --extra-experimental-features 'nix-command flakes' \
        flake update --flake "$SRC_ROOT/nix" "$@"
    then
        print_error "Flake update failed (see the error above). The existing lock is unchanged."
        exit 1
    fi
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

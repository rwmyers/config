#!/bin/zsh

NOTE='\033[1;32m'
ERROR='\033[1;31m'
NC='\033[0m'
SRC_ROOT="$HOME/src/config"

print_note()
{
    # Prefer gum's leveled, styled logging; fall back to plain colored output
    # before gum is available (e.g. a fresh machine, pre-Nix).
    if type gum > /dev/null 2>&1
    then
        gum log --level info -- "$1"
    else
        printf "${NOTE}$1${NC}\n"
    fi
}

print_error()
{
    # Errors: gum's error level when available, red text otherwise. To stderr.
    if type gum > /dev/null 2>&1
    then
        gum log --level error -- "$1"
    else
        printf "${ERROR}$1${NC}\n" >&2
    fi
}

path_append()
{
    # Append a directory to PATH unless it's already there. The directory need
    # not exist yet — setup creates several of them as it goes.
    case ":$PATH:" in
        *":$1:"*) ;;
        *) export PATH="$PATH:$1" ;;
    esac
}

source_nix_env()
{
    # Put Nix (and the Home Manager profile) on PATH for this process and every
    # child it spawns. Setup can't rely on inheriting it: these scripts run
    # non-interactively, so zsh never reads ~/.zshrc, and the login shell may not
    # be zsh at all. Mirrors .zshrc: nix-daemon.sh first, nix.sh as the fallback
    # for builds that drop it. No-op before Nix is installed, and safe to call
    # repeatedly. Returns non-zero if Nix still isn't usable afterwards.
    if ! type nix > /dev/null 2>&1
    then
        for profile_script in /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh \
                              /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        do
            if [ -e "$profile_script" ]
            then
                source "$profile_script"
                break
            fi
        done
    fi
    type nix > /dev/null 2>&1
}

setup_path()
{
    # Build the PATH setup itself needs. These scripts run non-interactively, so
    # zsh never reads ~/.zshrc, and the login shell they were launched from may
    # not be zsh at all — nothing can be assumed to be inherited. Covers the same
    # home-relative bin dirs .zshrc exports, plus Nix. Safe to call repeatedly.
    source_nix_env
    path_append "$HOME/bin"
    path_append "$HOME/bin.local"
    path_append "$HOME/.local/bin"
    path_append "$HOME/.cargo/bin"
    path_append "$HOME/go/bin"
    path_append "/usr/local/go/bin"
}

feature_enabled()
{
    # True if the given optional feature is enabled in ~/.config/dotfiles.conf
    # (the same file the nix config reads; written by install/features.sh).
    local conf="$HOME/.config/dotfiles.conf"
    [ -f "$conf" ] || return 1
    grep -qx "$1=true" "$conf"
}

flatpak_install()
{
    # Install a Flathub app if it isn't already present, setting up flatpak
    # and the flathub remote on first use.
    local app="$1"
    install_linux_package flatpak
    flatpak remotes | grep -q flathub \
        || sudo flatpak remote-add --if-not-exists flathub \
            https://dl.flathub.org/repo/flathub.flatpakrepo
    if ! flatpak info "$app" > /dev/null 2>&1
    then
        print_note " -- Installing $app"
        sudo flatpak install -y flathub "$app"
    fi
}

install_linux_package()
{
    local check="$1"
    # Use the check as package if not provided.
    local pkg="${2:-$check}"
    # Use the package if there is not an arch package.
    local arch_pkg="${3:-$pkg}"

    if [[ "$OSTYPE" == "linux-gnu"* ]];
    then
        if ! type "${check}" > /dev/null;
        then
            print_note "Installing ${pkg}"
            if [ -f "/etc/arch-release" ]
            then
                sudo pamac install ${arch_pkg}
            else
                sudo apt -y install ${pkg}
            fi
        fi
    fi
}

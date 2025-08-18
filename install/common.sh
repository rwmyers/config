#!/bin/zsh

NOTE='\033[1;32m'
NC='\033[0m'
SRC_ROOT="$HOME/src/config"

print_note()
{
    printf "${NOTE}$1${NC}\n"
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

install_snap()
{
    if [[ "$OSTYPE" == "linux-gnu"* ]];
    then
        if ! type "$1" > /dev/null;
        then
            print_note "Installing $1"
            sudo snap install $1
        fi
    fi
}

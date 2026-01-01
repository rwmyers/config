#!/bin/zsh

# Go language (https://go.dev/doc/install)
source $HOME/src/config/install/common.sh

if [ ! -d "/usr/local/go/bin/" ]
then
    print_note "-- Installing golang"
    LATEST_VERSION=$(curl -s "https://go.dev/VERSION?m=text" | head -n 1)
    print_note "   Latest version detected: $LATEST_VERSION"
    if [[ -z "$LATEST_VERSION" ]]; then
        echo "Error: Could not determine latest version. Please check your internet connection."
        exit 1
    fi

    OS="linux"
    ARCH="amd64"
    TAR_NAME="$LATEST_VERSION.$OS-$ARCH.tar.gz"
    DOWNLOAD_URL="https://go.dev/dl/$TAR_NAME"

    curl -OL "$DOWNLOAD_URL"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "$TAR_NAME"
    rm $TAR_NAME

fi

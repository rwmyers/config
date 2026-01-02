#!/bin/zsh

source $HOME/src/config/install/common.sh
SRC=$HOME/src

# Elephant - Data service provider and back end (https://github.com/abenz1267/elephant)
if [ ! -e "/usr/bin/elephant" ]
then
    print_note "-- Building elephant"
    pushd $SRC
    git clone https://github.com/abenz1267/elephant
    pushd elephant

    # Build the main binary
    pushd cmd/elephant
    go install elephant.go
    sudo cp $HOME/go/bin/elephant /usr/bin/elephant
    popd # cmd/elephant

    # Create configuration directory
    local PROVIDERS_DIR=$HOME/.config/elephant/providers
    mkdir -p $PROVIDERS_DIR

    print_note "--- Building desktopapplications provider"
    pushd internal/providers/desktopapplications
    go build -buildmode=plugin
    cp desktopapplications.so $PROVIDERS_DIR
    popd # internal/providers/desktopapplications
    popd # elephant
    popd # SRC

    # Create an elephant system service and start it
    print_note "--- Creating elephant user service"
    elephant service enable
    systemctl --user start elephant
fi

# Walker - An application launcher (https://github.com/abenz1267/walker)
if [ ! -e "/usr/bin/walker" ]
then
    print_note "-- Building walker"
    pushd $SRC
    git clone https://github.com/abenz1267/walker.git
    pushd walker
    # Dependency of walker
    sudo apt install libpoppler-glib-dev
    # Build release target
    cargo build --release
    sudo cp target/release/walker /usr/bin/walker
    popd # walker
    popd # SRC
fi

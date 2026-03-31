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

    # Enable the service
    systemctl --user daemon-reload
    systemctl --user reenable --now elephant.service
fi

# Websearch provider for elephant
local PROVIDERS_DIR=$HOME/.config/elephant/providers
if [ ! -e "$PROVIDERS_DIR/websearch.so" ]
then
    print_note "--- Building websearch provider"
    pushd $SRC/elephant/internal/providers/websearch
    go build -buildmode=plugin
    cp websearch.so $PROVIDERS_DIR
    popd # internal/providers/websearch
fi

# Bookmarks provider for elephant
if [ ! -e "$PROVIDERS_DIR/bookmarks.so" ]
then
    print_note "--- Building bookmarks provider"
    pushd $SRC/elephant/internal/providers/bookmarks
    go build -buildmode=plugin
    cp bookmarks.so $PROVIDERS_DIR
    popd # internal/providers/bookmarks
fi

# Generate websearch config with correct icon path
if [ ! -e "$HOME/.config/elephant/websearch.toml" ]
then
    print_note " -- Creating websearch config"
    cat > "$HOME/.config/elephant/websearch.toml" <<EOF
command = "webapp-open"

[[entries]]
name = "Google"
default = true
url = "https://www.google.com/search?q=%TERM%"
icon = "$HOME/.config/elephant/icons/google.png"
EOF
fi

# Download websearch icon
local ICONS_DIR=$HOME/.config/elephant/icons
if [ ! -e "$ICONS_DIR/google.png" ]
then
    print_note " -- Downloading Google icon"
    mkdir -p $ICONS_DIR
    curl -sL -o "$ICONS_DIR/google.png" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google.png"
fi

# Walker - An application launcher (https://github.com/abenz1267/walker)
if [ ! -e "/usr/bin/walker" ]
then
    print_note "-- Building walker"
    pushd $SRC
    git clone https://github.com/abenz1267/walker.git
    pushd walker
    # Dependency of walker
    sudo apt install libpoppler-glib-dev libgtk-4-dev libgtk4-layer-shell-dev libgtk-4-dev protobuf-compiler libprotobuf-dev
    # Build release target
    cargo build --release
    sudo cp target/release/walker /usr/bin/walker
    popd # walker
    popd # SRC
fi

if [ ! -d "$HOME/.config/walker/themes/default/" ]
then
    print_note "-- Linking walker theme data"
    mkdir -p $HOME/.config/walker/themes/default/
    ln -s $SRC_ROOT/.config/walker/themes/default/layout.xml $HOME/.config/walker/themes/default/layout.xml
    ln -s $SRC_ROOT/.config/walker/themes/default/style.css $HOME/.config/walker/themes/default/style.css
fi

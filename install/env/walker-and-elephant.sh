#!/bin/zsh

source $HOME/src/config/install/common.sh
SRC=$HOME/src

# Wayland launcher (walker) + its backend (elephant); Linux-only.
[[ "$OSTYPE" == "linux-gnu"* ]] || exit 0

# Both builds need a C toolchain: walker's crates compile C, and elephant's
# providers are -buildmode=plugin, which forces cgo. Without cc the Rust build
# dies on "linker `cc` not found" and every plugin build fails, leaving walker
# missing and elephant with an empty providers directory.
install_linux_package cc build-essential base-devel

# Walker's own build dependencies. Installed up front so a failure here is
# obvious rather than surfacing later as a broken build.
if [[ ! -f "/etc/arch-release" ]]
then
    sudo apt -y install libpoppler-glib-dev libgtk-4-dev libgtk4-layer-shell-dev \
        protobuf-compiler libprotobuf-dev
fi

PROVIDERS_DIR=$HOME/.config/elephant/providers
mkdir -p $PROVIDERS_DIR

# Elephant - Data service provider and back end (https://github.com/abenz1267/elephant)
if [ ! -d "$SRC/elephant" ]
then
    print_note "-- Cloning elephant"
    git clone https://github.com/abenz1267/elephant $SRC/elephant
fi

if [ ! -e "/usr/bin/elephant" ]
then
    print_note "-- Building elephant"
    pushd $SRC/elephant/cmd/elephant
    go install elephant.go
    sudo cp $HOME/go/bin/elephant /usr/bin/elephant
    popd # cmd/elephant

    # Not "elephant service enable" - that generates its own unit file, which
    # would land on top of the one this repo tracks. 00-systemd-user.sh has
    # already linked ours into place.
    print_note "--- Enabling elephant user service"
    systemctl --user daemon-reload
    systemctl --user reenable --now elephant.service
fi

# Elephant providers. Each is guarded on its own .so rather than on the elephant
# binary: a provider added later still gets built on a machine that already has
# elephant installed.
for provider in desktopapplications websearch bookmarks
do
    if [ ! -e "$PROVIDERS_DIR/$provider.so" ]
    then
        print_note "--- Building $provider provider"
        pushd $SRC/elephant/internal/providers/$provider
        go build -buildmode=plugin
        cp $provider.so $PROVIDERS_DIR
        popd # internal/providers/$provider
    fi
done

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
ICONS_DIR=$HOME/.config/elephant/icons
if [ ! -e "$ICONS_DIR/google.png" ]
then
    print_note " -- Downloading Google icon"
    mkdir -p $ICONS_DIR
    curl -sL -o "$ICONS_DIR/google.png" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google.png"
fi

# Walker - An application launcher (https://github.com/abenz1267/walker)
if [ ! -d "$SRC/walker" ]
then
    print_note "-- Cloning walker"
    git clone https://github.com/abenz1267/walker.git $SRC/walker
fi

if [ ! -e "/usr/bin/walker" ]
then
    print_note "-- Building walker"
    pushd $SRC/walker
    cargo build --release
    sudo cp target/release/walker /usr/bin/walker
    popd # walker
fi

if [ ! -d "$HOME/.config/walker/themes/default/" ]
then
    print_note "-- Linking walker theme data"
    mkdir -p $HOME/.config/walker/themes/default/
    ln -s $SRC_ROOT/.config/walker/themes/default/layout.xml $HOME/.config/walker/themes/default/layout.xml
    ln -s $SRC_ROOT/.config/walker/themes/default/style.css $HOME/.config/walker/themes/default/style.css
fi

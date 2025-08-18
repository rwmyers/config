#!/bin/zsh

source install/common.sh

# Fonts
FONT_DIR="$HOME/.local/share/fonts"
FONT_CONFIG_DIR="$SRC_ROOT/fonts"

mkdir -p "$FONT_DIR"

# The (N) is a Zsh "glob qualifier" that makes the pattern
# expand to an empty list if no files match (null glob).
files=("$FONT_DIR"/CaskaydiaMono*(N))

if (( ${#files[@]} == 0 )); then
    print_note "Downloading CaskaydiaMono Nerd Fonts"
    font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaMono.zip"
    font_tmp_dir="$HOME/tmp_fonts"
    mkdir -p $font_tmp_dir
    pushd $font_tmp_dir
    wget $font_url
    unzip -o CascadiaMono.zip -d $FONT_DIR
    popd $font_tmp_dir
    rm -rf $font_tmp_dir
fi

files=("$FONT_DIR"/MesloLGS*(N))

if (( ${#files[@]} == 0 )); then
    print_note "Copying fonts from config"
    cp $FONT_CONFIG_DIR/* $FONT_DIR
fi

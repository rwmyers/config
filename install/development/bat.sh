#!/bin/zsh

# bat - config + themes only. The bat binary is provided by Home Manager
# (nix/home.nix).
# https://github.com/sharkdp/bat

source $HOME/src/config/install/common.sh

# bat configuration
if [ ! -d "$HOME/.config/bat" ]
then
    print_note " -- Linking bat configuration"
    ln -s $HOME/src/config/.config/bat ~/.config/bat
fi

# Catppuccin themes (https://github.com/catppuccin/bat)
local bat_config_dir="$(bat --config-dir)"
if [ ! -d "$bat_config_dir/themes" ]
then
    print_note " -- Installing Catppuccin bat themes"
    mkdir -p "$bat_config_dir/themes"
    local base_url="https://github.com/catppuccin/bat/raw/main/themes"
    curl -LSso "$bat_config_dir/themes/Catppuccin Latte.tmTheme" "$base_url/Catppuccin%20Latte.tmTheme"
    curl -LSso "$bat_config_dir/themes/Catppuccin Frappe.tmTheme" "$base_url/Catppuccin%20Frappe.tmTheme"
    curl -LSso "$bat_config_dir/themes/Catppuccin Macchiato.tmTheme" "$base_url/Catppuccin%20Macchiato.tmTheme"
    curl -LSso "$bat_config_dir/themes/Catppuccin Mocha.tmTheme" "$base_url/Catppuccin%20Mocha.tmTheme"
    bat cache --build
fi

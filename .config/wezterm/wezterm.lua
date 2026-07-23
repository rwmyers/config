local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("CaskaydiaMono Nerd Font")
config.font_size = 11

config.color_scheme = "Catppuccin Macchiato"
config.window_background_opacity = 0.95

config.scrollback_lines = 90000
config.hide_tab_bar_if_only_one_tab = true

return config

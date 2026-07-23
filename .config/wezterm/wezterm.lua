local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("Hack Nerd Font")
config.font_size = 13

config.color_scheme = "rose-pine"
config.window_background_opacity = 0.9

config.scrollback_lines = 90000
config.hide_tab_bar_if_only_one_tab = true

return config

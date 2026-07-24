local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("Hack Nerd Font")
config.font_size = 13

-- Follow the active theme: each theme ships a wezterm.lua colour table (see
-- themes/<name>/wezterm.lua), mirroring how alacritty imports its per-theme
-- toml. `themes/current` is flipped by bin/system-menu, which nudges wezterm
-- to reload.
local theme = os.getenv("HOME") .. "/themes/current/wezterm.lua"
local ok, colors = pcall(dofile, theme)
if ok and type(colors) == "table" then
	config.colors = colors
	wezterm.add_to_config_reload_watch_list(theme)
else
	config.color_scheme = "rose-pine"
end

config.window_background_opacity = 0.9

config.scrollback_lines = 90000
config.hide_tab_bar_if_only_one_tab = true

return config

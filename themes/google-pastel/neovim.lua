-- No upstream Neovim colorscheme ships this palette, so lean on
-- catppuccin's dark "mocha" flavour to keep the editor consistent with
-- the rest of the google-pastel (dark) theme.
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
			})
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin-mocha",
		},
	},
}

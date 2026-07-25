return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- other options: "latte", "frappe", "macchiato"
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}

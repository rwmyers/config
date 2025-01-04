-- VIM Configuration File

-- allows backspace over anything
vim.opt.backspace = { 'indent', 'eol', 'start' }

-- show whitespace
vim.opt.list = true
vim.opt.listchars = { eol = '$', tab = '>-', trail = '~', extends = '>', precedes = '<' }

-- show line numbers
vim.opt.number = true

-- tabs and auto-indent
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- show status bar
vim.opt.laststatus = 2

vim.cmd('colorscheme molokai')

-- syntax
vim.opt.syntax = 'on'

vim.keymap.set('n', '<M-Right>', ':bn!<CR>')
vim.keymap.set('n', '<M-Left>', ':bp!<CR>')

-- filetypes
vim.opt.filetype = 'on'

require("config.lazy")

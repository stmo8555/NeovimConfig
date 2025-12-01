vim.o.number = true
vim.o.signcolumn = "yes"
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4

vim.o.swapfile = false
vim.g.mapleader = " "

vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')

vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':qa<CR>')
vim.pack.add({
		{src = "https://github.com/vague2k/vague.nvim"},
		{src = "https://github.com/stevearc/oil.nvim"},
		{src = "https://github.com/echasnovski/mini.pick"},
		{src = "https://github.com/neovim/nvim-lspconfig"},
		{src = "https://github.com/chomosuke/typst-preview.nvim"},
		{src = "https://github.com/mason-org/mason.nvim"},
})
require "mini.pick".setup()
require "oil".setup()
vim.keymap.set('n', '<leader>f', ':Pick files<CR>')
vim.keymap.set('n', '<leader>h', ':Pick help<CR>')
vim.keymap.set('n', '<leader>e', ':Oil<CR>')

require "mason".setup()
vim.lsp.enable({"lua_ls"})
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

vim.cmd("colorscheme vague")

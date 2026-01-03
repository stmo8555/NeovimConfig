vim.o.number = true
vim.o.signcolumn = "yes"
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.shiftwidth = 2
vim.o.swapfile = false
vim.o.clipboard = "unnamedplus"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.keymap.set("v", "<Space>", "<Nop>", { silent = true })

vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':q<CR>')
vim.keymap.set('n', '<leader>qa', ':qa<CR>')
vim.keymap.set('i', 'jj', '<Esc>', {noremap = true, silent = true})


require "plugins.vague"
require "plugins.oil"
require "plugins.mini"
require "plugins.treesitter"
require "plugins.mason"
require "plugins.lsp"



vim.keymap.set('n', '<leader>f', ':Pick files<CR>')
vim.keymap.set('n', '<leader>h', ':Pick help<CR>')
vim.keymap.set('n', '<leader>e', ':Oil<CR>')
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

vim.o.number = true
vim.o.signcolumn = "yes"
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 2
vim.o.swapfile = false
vim.g.mapleader = " "

vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':q<CR>')
vim.keymap.set('n', '<leader>qa', ':qa<CR>')

require "config.lazy"
require "mini.statusline".setup({use_icons = true})
require "mini.pick".setup()
require "mini.git".setup()

vim.cmd("colorscheme vague")

--require "oil".setup()
vim.keymap.set('n', '<leader>f', ':Pick files<CR>')
vim.keymap.set('n', '<leader>h', ':Pick help<CR>')
--vim.keymap.set('n', '<leader>e', ':Oil<CR>')
vim.keymap.set('n', '<leader>gs', ':Git status<CR>')
vim.keymap.set('n', '<leader>ga', ':Git add')
vim.keymap.set('n', '<leader>ga.', ':Git add .<CR>')
vim.keymap.set('n', '<leader>gc', ':Git commit <CR>')
vim.keymap.set('n', '<leader>gp', ':Git push')

vim.lsp.enable({"lua_ls"})
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

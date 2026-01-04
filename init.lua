vim.o.number = true
vim.o.signcolumn = 'yes'
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.shiftwidth = 1
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.swapfile = false
vim.o.clipboard = 'unnamedplus'
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


vim.keymap.set('n', '<Space>', '<Nop>', { silent = true })
vim.keymap.set('v', '<Space>', '<Nop>', { silent = true })

vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>w', ':write<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>q', ':q<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>qa', ':qa<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>qq', ':qa!<CR>', { noremap = true, silent = true })
vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('n', 'm', '@q', { noremap = true, silent = true })

require 'plugins.vague'
require 'plugins.oil'
require 'plugins.mini'
require 'plugins.treesitter'
require 'plugins.lsp'
require 'plugins.blink-cmp'

vim.keymap.set('n', '<leader>f', ':Pick files<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>h', ':Pick help<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>e', ':Oil<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
})

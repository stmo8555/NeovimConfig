vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.o.number = true
vim.o.signcolumn = 'yes'
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.swapfile = false

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
vim.o.confirm = true

local auto = vim.api.nvim_create_autocmd

auto('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

auto('FileType', {
  group = vim.api.nvim_create_augroup('no_auto_comment', {}),
  callback = function()
    vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
  end,
})

auto('VimResized', { command = 'wincmd =' })
auto('FileType', { pattern='help', command='wincmd L',})


local opts = { noremap = true, silent = true }
local set = vim.keymap.set
set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps improve
set('n', '<leader>d', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

set('n', '<Space>', '<Nop>', opts)
set('v', '<Space>', '<Nop>', opts)

set('n', '<leader>o', ':update<CR> :source<CR>', opts)
set('n', '<leader>w', ':write<CR>', opts)
set('n', '<leader>q', ':q<CR>', opts)
set('n', '<leader>qa', ':qa<CR>', opts)
set('n', '<leader>qq', ':qa!<CR>', opts)
set('i', 'jj', '<Esc>', opts)
set('n', '<C-q>', '@q', opts)

require('plugins.vague')
require('plugins.oil')
require('plugins.mini')
require('plugins.treesitter')
require('plugins.lsp')
require('plugins.blink-cmp')
--require('plugins.multicursor')
require('plugins.autopair')
require('plugins.winshift')
require('plugins.marks')

set('n', '<leader>f', ':Pick files<CR>', opts)
set('n', '<leader>h', ':Pick help<CR>', opts)
set("n", "<leader>fn",
  function() require('mini.pick').builtin.files({}, { source = { cwd = vim.fn.stdpath("config"), }, }) end,
  { desc = "Pick files from Neovim config" })
set('n', '<leader>e', ':Oil<CR>', opts)
set('n', '<leader>en', function() require('oil').open(vim.fn.stdpath('config') .. '/lua/plugins') end, opts)
set('n', '<leader>lf', vim.lsp.buf.format)

--" Start Win-Move mode:
set('n', '<C-W>m', '<Cmd>WinShift<CR>', opts)

--" Swap two windows:
set('n', '<C-W>X', '<Cmd>WinShift swap<CR>')

--" If you don't want to use Win-Move mode you can create mappings for calling the
--" move commands directly:
--set('n', '<C-M>h', '<Cmd>WinShift left<CR>')
--set('n', '<C-M>j', '<Cmd>WinShift down<CR>')
--set('n', '<C-M>k', '<Cmd>WinShift up<CR>')
--set('n', '<C-M>l', '<Cmd>WinShift right<CR>')

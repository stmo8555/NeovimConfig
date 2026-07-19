vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.winborder = "rounded"
vim.o.number = true
vim.o.signcolumn = 'yes'
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.swapfile = false
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.cursorline = true
vim.o.showmode = false
vim.o.laststatus = 3

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
vim.o.confirm = true

-- Automatically reload files changed outside of Neovim
vim.o.autoread = true
vim.o.updatetime = 1000
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

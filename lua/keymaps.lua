local opts = { silent = true }
local set = vim.keymap.set

-- Disable Ctrl+u in insert mode
set('i', '<C-u>', '<Nop>', opts)
set('n', '<Esc>', '<cmd>nohlsearch<CR>', opts)

set("n", "<C-j>", function() vim.fn.append(vim.fn.line("."), "") end)
set("n", "<C-k>", function() vim.fn.append(vim.fn.line(".") - 1, "") end)

set('n', '<Space>', '<Nop>', opts)
set('v', '<Space>', '<Nop>', opts)

set('n', '<leader>o', function()
  vim.cmd.update()

  local config = vim.fn.stdpath('config')
  local config_lua = vim.fs.normalize(config .. '/lua')

  for _, path in ipairs(vim.fn.globpath(config_lua, '**/*.lua', false, true)) do
    local module = path:sub(#config_lua + 2, -5):gsub('/', '.')
    package.loaded[module] = nil

    if vim.endswith(module, '.init') then
      package.loaded[module:sub(1, -6)] = nil
    end
  end

  vim.cmd.source(config .. '/init.lua')
  vim.api.nvim_echo({ { 'Sourced config' } }, false, {})
end, opts)
set('n', '<leader>w', ':write<CR>', opts)
set('n', '<leader>q', ':q<CR>', opts)

set('i', 'jj', '<Esc>', opts)
set('n', '<C-q>', '@q', opts)

set({ 'n', 'v', 'x' }, 'D', '"_d', opts)

set('n', '<C-Left>', ':vertical resize -5<CR>', { silent = true })
set('n', '<C-Right>', ':vertical resize +5<CR>', { silent = true })

set("n", "grn", function() require("plugins.rename_float").rename() end, { desc = "LSP rename float" })

local MiniPick = require("mini.pick")

set('n', '<leader>ff', ':Pick files<CR>', opts)
set('n', '<leader>fh', ':Pick help<CR>', opts)
set('n', '<leader>fg', ':Pick grep_live<CR>', opts)
set("n", "<leader>fn",
    function() MiniPick.builtin.files({}, { source = { cwd = vim.fn.stdpath("config"), }, }) end,
    { desc = "Pick files from Neovim config" })
set("n", "<leader>fl",
    function() MiniPick.builtin.files({}, { source = { cwd = vim.fn.expand('%:p:h') }, }) end,
    { desc = "Pick files locally" })
set('n', '<leader>fc', function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end, opts)

set('n', '<leader>e', ':Oil<CR>', opts)

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
set("n", "<C-d>", "<C-d>zz", { desc = "move down in buffer with cursor centerd" })
set("n", "<C-u>", "<C-u>zz", { desc = "move up in buffer with cursor centerd" })

set("n", "n", "nzzzv", { desc = "move down in buffer with cursor centerd" })
set("n", "N", "Nzzzv", { desc = "move down in buffer with cursor centerd" })


set("n", "<leader>m", function() require("arena").toggle() end)

vim.keymap.set('n', 'gz', function()
  if vim.g.pane_zoomed then
    vim.cmd('wincmd =')
    vim.g.pane_zoomed = false
  else
    vim.cmd('wincmd |')
    vim.g.pane_zoomed = true
  end
end)

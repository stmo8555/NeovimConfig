local set = vim.keymap.set

-- Disable Ctrl+u in insert mode
set('i', '<C-u>', '<Nop>', { silent = true, desc = 'Disable insert-mode delete to line start' })
set('n', '<Esc>', '<cmd>nohlsearch<CR>', { silent = true, desc = 'Clear search highlight' })

set("n", "<C-j>", function() vim.fn.append(vim.fn.line("."), "") end, { desc = "Insert blank line below" })
set("n", "<C-k>", function() vim.fn.append(vim.fn.line(".") - 1, "") end, { desc = "Insert blank line above" })

set('n', '<Space>', '<Nop>', { silent = true, desc = 'Disable Space key' })
set('v', '<Space>', '<Nop>', { silent = true, desc = 'Disable Space key' })

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
end, { silent = true, desc = 'Reload Neovim configuration' })
set('n', '<leader>w', ':write<CR>', { silent = true, desc = 'Write current buffer' })
set('n', '<leader>q', ':q<CR>', { silent = true, desc = 'Quit current window' })

set('i', 'jj', '<Esc>', { silent = true, desc = 'Exit insert mode' })
set('n', '<C-q>', '@q', { silent = true, desc = 'Replay q macro' })

set({ 'n', 'v', 'x' }, 'D', '"_d', { silent = true, desc = 'Delete without yanking' })

set('n', '<C-Left>', ':vertical resize -5<CR>', { silent = true, desc = 'Decrease window width' })
set('n', '<C-Right>', ':vertical resize +5<CR>', { silent = true, desc = 'Increase window width' })

set("n", "grn", function() require("plugins.rename_float").rename() end, { desc = "LSP rename float" })

local MiniPick = require("mini.pick")

set('n', '<leader>ff', ':Pick files<CR>', { silent = true, desc = 'Find files' })
set('n', '<leader>fh', ':Pick help<CR>', { silent = true, desc = 'Find help' })
set('n', '<leader>fg', ':Pick grep_live<CR>', { silent = true, desc = 'Live grep' })
set("n", "<leader>fn",
    function() MiniPick.builtin.files({}, { source = { cwd = vim.fn.stdpath("config"), }, }) end,
    { desc = "Pick files from Neovim config" })
set("n", "<leader>fl",
    function() MiniPick.builtin.files({}, { source = { cwd = vim.fn.expand('%:p:h') }, }) end,
    { desc = "Pick files locally" })
set('n', '<leader>fc', function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end,
  { silent = true, desc = 'Grep word under cursor' })

set('n', '<leader>e', ':Oil<CR>', { silent = true, desc = 'Open file explorer' })

set('n', '<leader>lf', vim.lsp.buf.format, { desc = 'Format buffer' })

--" Start Win-Move mode:
set('n', '<C-W>m', '<Cmd>WinShift<CR>', { silent = true, desc = 'Enter window move mode' })

--" Swap two windows:
set('n', '<C-W>X', '<Cmd>WinShift swap<CR>', { desc = 'Swap windows' })

--" If you don't want to use Win-Move mode you can create mappings for calling the
--" move commands directly:
--set('n', '<C-M>h', '<Cmd>WinShift left<CR>')
--set('n', '<C-M>j', '<Cmd>WinShift down<CR>')
--set('n', '<C-M>k', '<Cmd>WinShift up<CR>')
--set('n', '<C-M>l', '<Cmd>WinShift right<CR>')
set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor" })
set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center cursor" })

set("n", "n", "nzzzv", { desc = "Next search result and center cursor" })
set("n", "N", "Nzzzv", { desc = "Previous search result and center cursor" })


set("n", "<leader>m", function() require("arena").toggle() end, { desc = "Toggle Arena" })

vim.keymap.set('n', 'gz', function()
  if vim.g.pane_zoomed then
    vim.cmd('wincmd =')
    vim.g.pane_zoomed = false
  else
    vim.cmd('wincmd |')
    vim.g.pane_zoomed = true
  end
end, { desc = 'Toggle window zoom' })

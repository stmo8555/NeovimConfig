require("vim._core.ui2").enable({})
require("options")

require('plugins.vague')
require('plugins.oil')
require('plugins.mini')
require('plugins.lsp')
require('plugins.autopair')
require('plugins.winshift')
require('plugins.autotag')
require('plugins.aerial')
require('plugins.dap')
require('plugins.ai')

require('plugins.arena')
require('arena').setup()

vim.pack.add({ "https://github.com/junegunn/vim-peekaboo" })


require("keymaps")
require("autos")

vim.keymap.set('n', '<leader>z', function()
  if vim.g.pane_zoomed then
    vim.cmd('wincmd =')
    vim.g.pane_zoomed = false
  else
    vim.cmd('wincmd |')
    vim.g.pane_zoomed = true
  end
end)

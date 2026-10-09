require("vim._core.ui2").enable({})
require("options")

require('plugins.oil')
require('plugins.mini')
require('plugins.lsp')
require('plugins.autopair')
require('plugins.winshift')
require('plugins.autotag')
require('plugins.aerial')
require('plugins.dap')
require('plugins.undotree')

require('plugins.arena')
require('arena').setup()

vim.pack.add({ "https://github.com/junegunn/vim-peekaboo" })


require("keymaps")
require("prompter")
require("autos")

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    for _, group in ipairs({
      'Normal', 'NormalNC', 'NormalFloat', 'FloatBorder', 'SignColumn',
      'EndOfBuffer', 'LineNr', 'FoldColumn', 'StatusLine', 'StatusLineNC',
    }) do
      vim.api.nvim_set_hl(0, group, vim.tbl_extend('force',
        vim.api.nvim_get_hl(0, { name = group, link = false }), { bg = 'NONE' }))
    end
  end,
})

vim.cmd.colorscheme('catppuccin')

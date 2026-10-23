require("vim._core.ui2").enable({})
require("options")

require('plugins.undotree')
require('colorscheme')

require("keymaps")
require("prompter")



require("lsp")
require("netrw")
require("statusline")
require("find")
require("grep")
require("autocommands")
require("diagnostics")
require("formatting")
require("textobjects")

vim.filetype.add({ extension = { gpr = "gpr" } })
-- keep Ada syntax highlighting for project files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gpr",
  callback = function() vim.bo.syntax = "ada" end,
})

vim.lsp.enable({"ada_ls", "lua_ls"})

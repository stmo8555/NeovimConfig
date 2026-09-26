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

vim.lsp.enable({"ada_ls", "lua_ls"})

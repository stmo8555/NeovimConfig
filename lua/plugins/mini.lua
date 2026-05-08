vim.pack.add({ "https://github.com/nvim-mini/mini.nvim.git" })

require "mini.icons".setup()
require "mini.statusline".setup({ use_icons = true })
require "mini.pick".setup()
require 'mini.surround'.setup()
require 'mini.move'.setup()
require("mini.indentscope").setup()
require("mini.splitjoin").setup()

require("mini.extra").setup()

vim.keymap.set("n", "grr", function()
    require("mini.extra").pickers.lsp({ scope = "references" })
end, { desc = "LSP references" })

vim.keymap.set("n", "<leader>dd", function()
    require("mini.extra").pickers.diagnostic({
        scope = "current",
    })
end, { desc = "Buffer diagnostics" })

vim.keymap.set("n", "<leader>da", function()
    require("mini.extra").pickers.diagnostic({
        scope = "all",
    })
end, { desc = "Workspace diagnostics" })

vim.keymap.set("n", "<leader>de", function()
    vim.diagnostic.open_float(nil, {
        scope = "cursor",
        focus = true,
        border = "rounded",
        source = true,
    })
end, { desc = "Show diagnostic details" })

vim.keymap.set("n", "<leader>dl", function()
  vim.diagnostic.config({
    virtual_lines = not vim.diagnostic.config().virtual_lines,
  })
end, { desc = "Toggle diagnostic lines" })

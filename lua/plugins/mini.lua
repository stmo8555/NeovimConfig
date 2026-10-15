vim.pack.add({ "https://github.com/nvim-mini/mini.nvim.git" })

require "mini.icons".setup()
require "mini.statusline".setup({ use_icons = true })
require "mini.pick".setup({
    window = {
        -- Centered on screen
        config = function()
            local height = math.floor(0.618 * vim.o.lines)
            local width = math.floor(0.85 * vim.o.columns)
            return {
                anchor = "NW",
                height = height,
                width = width,
                row = math.floor(0.5 * (vim.o.lines - height)),
                col = math.floor(0.5 * (vim.o.columns - width)),
            }
        end,
    },
})


require 'mini.surround'.setup()
require 'mini.move'.setup()
require "mini.indentscope".setup()
require "mini.splitjoin".setup()
require "mini.extra".setup()
require "mini.sessions".setup({ autoread = true, })
require "mini.notify".setup()

vim.keymap.set("n", "<leader>nc", function()
    require("mini.notify").clear()
end, { desc = "Clear notifications" })

vim.keymap.set("n", "<leader>nh", function()
    require("mini.notify").show_history()
end, { desc = "Notification history" })

vim.keymap.set("n", "<leader>ss", function()
    require("mini.sessions").write("Session.vim")
end, { desc = "Save session" })

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
        scope = "line",
        focus = true,
        border = "rounded",
        source = true,
    })
end, { desc = "Show diagnostic details" })

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

-- jdtls fires nonstop $/progress updates while indexing/building; mini.notify
-- reads its lsp_progress.enable setting live on every event, so just flip it
-- off while focused on a java buffer instead of touching LSP handlers.
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(args)
        local ok, notify = pcall(require, "mini.notify")
        if ok then
            notify.config.lsp_progress.enable = vim.bo[args.buf].filetype ~= "java"
        end
    end,
})

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

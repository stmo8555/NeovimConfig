vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/olimorris/codecompanion.nvim" },
    { src = "https://github.com/j-hui/fidget.nvim" },
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" }
})

require("render-markdown").setup({
    latex = { enabled = false },
    file_types = { "markdown", "codecompanion" }
})

require("codecompanion").setup({
    adapters = {
        acp = {
            claude_code = function()
                return require("codecompanion.adapters").extend("claude_code", {
                    commands = {
                        default = { "claude-code-acp" },
                        yolo = { "claude-code-acp" },
                    },
                    env = {
                        CLAUDE_CODE_OAUTH_TOKEN = function()
                            return os.getenv("CLAUDE_CODE_OAUTH_TOKEN")
                        end,
                    },
                })
            end,
        },
    },
    strategies = {
        chat = { adapter = "claude_code" },
        inline = { adapter = "claude_code" },
        cmd = { adapter = "claude_code" },
    },
})

vim.keymap.set("n", "<leader>am", "<cmd>ToggleAIModel<cr>")
vim.keymap.set("n", "<leader>aM", "<cmd>CurrentAIModel<cr>")

vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat<cr>")
vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>")
vim.keymap.set("v", "<leader>ai", "<cmd>CodeCompanion<cr>")


local progress = require('fidget.progress')
local handles = {}
local group = vim.api.nvim_create_augroup("CodeCompanionFidget", {})

vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionRequestStarted",
    group = group,
    callback = function(e)
        handles[e.data.id] = progress.handle.create({
            title = "CodeCompanion",
            message = "Thinking...",
            lsp_client = { name = e.data.adapter.formatted_name },
        })
    end
})

vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionRequestFinished",
    group = group,
    callback = function(e)
        local h = handles[e.data.id]
        if h then
            h.message = e.data.status == "success" and "Done" or "Failed"
            h:finish()
            handles[e.data.id] = nil
        end
    end
})
vim.keymap.set("n", "<leader>a", "<Nop>", {
    desc = "Actions prefix",
})

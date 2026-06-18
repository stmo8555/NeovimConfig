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

local models = {
    {
        adapter = "anthropic",
        model = "Haiku-4.5",
    },
    {
        adapter = "openai",
        model = "gpt-5nano",
    },
}

local current_model = 1

local function active()
    return models[current_model]
end

local setup = function()
    require("codecompanion").setup({
        strategies = {
            chat = {
                adapter = active().adapter,
            },
            inline = {
                adapter = active().adapter
            },
            cmd = {
                adapter = active().adapter
            },
        },

        adapters = {
            anthropic = function()
                return require("codecompanion.adapters").extend("anthropic", {
                    schema = {
                        model = {
                            default = active().model,
                        },
                    },
                })
            end,

            openai = function()
                return require("codecompanion.adapters").extend("openai", {
                    schema = {
                        model = {
                            default = active().model,
                        },
                    },
                })
            end,
        },
    })
end

setup()

vim.api.nvim_create_user_command("ToggleAIModel", function()
    current_model = current_model + 1

    if current_model > #models then
        current_model = 1
    end

    local m = active()
    setup()
    print("Current AI model: " .. m.adapter .. " / " .. m.model)
end, {})

vim.api.nvim_create_user_command("CurrentAIModel", function()
    local m = active()
    print("Current AI model: " .. m.adapter .. " / " .. m.model)
end, {})

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

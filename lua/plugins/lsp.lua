vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig.git",
    "https://github.com/mason-org/mason.nvim.git",
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        version = "main"
    },
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    {
        src = 'https://github.com/saghen/blink.cmp',
        version = "v1"
    },
    "https://github.com/rafamadriz/friendly-snippets",
})

require "nvim-treesitter".install({
    "html", "css", "c", "cpp",
    "python", "lua", "vim", "bash",
    "regex", "markdown", "json", "go", "javascript", "sql", "yaml"
})

require "mason".setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require 'blink.cmp'.setup({
    fuzzy = { implementation = "prefer_rust" },

    keymap = { preset = 'default' },
    appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = 'mono'
    },
    signature = { enabled = true }
})

vim.lsp.config("cssls", {})
vim.lsp.config("html", {})
vim.lsp.config("gopls", {})
vim.lsp.config("lua_ls", {})

vim.lsp.config("postgres_lsp", {
    cmd = { "postgres-language-server", "lsp-proxy" },
    filetypes = { "sql" },
    root_dir = function(_, on_dir)
        on_dir(vim.fn.getcwd())
    end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

vim.lsp.config('*', {
    capabilities = capabilities
})

vim.lsp.config("tsgo", {})

vim.lsp.enable({
    "cssls",
    "html",
    "gopls",
    "lua_ls",
    "postgres_lsp",
    "tsgo",
})


vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

-- keymaps
-- You can use the capture groups defined in `textobjects.scm`
vim.keymap.set({ "x", "o" }, "af", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
end)

vim.keymap.set({ "x", "o" }, "if", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
end)

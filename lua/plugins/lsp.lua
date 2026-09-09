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

require('blink.cmp').setup({
    fuzzy = { implementation = "prefer_rust" },

    keymap = { preset = 'default' },

    appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = 'mono',
    },

    completion = {
        menu = {
            draw = {
                columns = {
                    { "label",      "label_description", gap = 1 },
                    { "kind" },
                    { "source_name" },
                },
            },
        },
    },

    signature = { enabled = true },
})

require "nvim-treesitter".install({
    "cmake", "html", "css", "c", "cpp",
    "python", "lua", "vim", "bash",
    "regex", "markdown", "json", "go", "javascript", "sql", "yaml", "asm"
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

local lsps = {
    "cssls",
    "html",
    "gopls",
    "lua_ls",
    "postgres_lsp",
    "tsgo",
    "asm_lsp",
    "clangd",
    "neocmake",
    "jsonls",
}

local mason_packages = {
    "css-lsp",
    "html-lsp",
    "json-lsp",
    "gopls",
    "lua-language-server",
    "postgres-language-server",
    "tsgo",
    "asm-lsp",
    "clangd",
}

local registry = require "mason-registry"

registry.refresh(function(success)
    if not success then
        return
    end

    for _, package_name in ipairs(mason_packages) do
        local package = registry.get_package(package_name)
        if not package:is_installed() or package:get_installed_version() ~= package:get_latest_version() then
            vim.notify("Installing " .. package_name)
            package:install()
        end
    end
end)

vim.lsp.config("gopls", {
    settings = {
        gopls = {
            usePlaceholders = true,
            completeFunctionCalls = true,
        },
    },
})

vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        -- glob, not g++: pico C sources are built with arm-none-eabi-gcc, and

        -- clangd only queries drivers this pattern matches
        "--query-driver=/usr/bin/arm-none-eabi-*",
        -- no --compile-commands-dir: clangd searches upward from each file, so
        -- nested projects each find their own compile_commands.json
        "--fallback-style={BasedOnStyle: LLVM, IndentWidth: 4, ColumnLimit: 80}",
    },
    init_options = {
        fallbackFlags = { "-std=c++20", "-Wall", "-Wextra", "-Wpedantic", "-Werror" },
    },
})

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


vim.lsp.enable(lsps)


vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

-- keymaps
-- You can use the capture groups defined in `textobjects.scm`
vim.keymap.set({ "x", "o" }, "af", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
end, { desc = "Select outer function" })

vim.keymap.set({ "x", "o" }, "if", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
end, { desc = "Select inner function" })

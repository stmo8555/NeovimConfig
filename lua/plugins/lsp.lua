vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig.git",
    "https://github.com/mason-org/mason.nvim.git",
    "https://github.com/mason-org/mason-lspconfig.nvim.git",
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        version = "main"
    },
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
})

local function packadd(name)
    vim.cmd("packadd " .. name)
end
packadd("nvim-treesitter")
packadd("mason.nvim")
packadd("mason-lspconfig.nvim")
packadd("nvim-lspconfig")




require "nvim-treesitter".setup({
    ensure_installed = {
        "html", "css", "c", "cpp",
        "python", "lua", "vim", "bash",
        "regex", "markdown", "json", "go", "javascript", "sql"
    },
    auto_install = false,
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
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

require("mason-lspconfig").setup()

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "*" },
    callback = function(args)
        local ft = vim.bo[args.buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)
        if vim.treesitter.language.add(lang) then
            vim.treesitter.start(args.buf, lang)
        end
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

vim.pack.add({
  "https://github.com/mason-org/mason.nvim.git",
  "https://github.com/mason-org/mason-lspconfig.nvim.git"
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

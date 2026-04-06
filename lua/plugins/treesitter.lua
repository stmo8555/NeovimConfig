vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main"
  }
})

require "nvim-treesitter".setup({
  ensure_installed = {
    "html", "css", "c", "cpp",
    "python", "lua", "vim", "bash",
    "regex", "markdown", "json", "go", "javascript"
  },
  auto_install = false,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})

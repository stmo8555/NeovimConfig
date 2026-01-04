vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "master"
  }
})

require "nvim-treesitter.configs".setup({
  ensure_installed = {
    "html", "css", "c", "cpp",
    "python", "lua", "vim", "bash",
    "regex", "markdown", "json", "go"
  },
  auto_install = false,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})

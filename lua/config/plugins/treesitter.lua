return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
    require("nvim-treesitter.configs").setup({
      ensure_instlinelled = {"html", "css", "c", "cpp", "python", "lua", "vim", "bash", "regex", "markdown" },
      highlight = { enable = true },
      indent = { enable = true },
    })
    end
  }
}

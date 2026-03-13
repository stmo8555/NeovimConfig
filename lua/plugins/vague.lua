vim.pack.add({
  "https://github.com/vague-theme/vague.nvim",
})

require("vague").setup({
  -- optional configuration here
    transparent = true
})

vim.cmd("colorscheme vague")

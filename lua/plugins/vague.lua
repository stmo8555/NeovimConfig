vim.pack.add({ 'https://github.com/vague-theme/vague.nvim' })
require('vague').setup({
  transparent = true, -- If true, background is not set
  bold = true, -- Disable bold globally
  italic = true, -- Disable italic globally
  colors = { visual = '#4a5568' },
})
vim.cmd.colorscheme('vague')

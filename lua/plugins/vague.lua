vim.pack.add({ 'https://github.com/vague-theme/vague.nvim' })

local state = { transparent = false }

-- vague.nvim's submodules each cache `config.internal.current` in a local at
-- require-time, and setup() replaces that table rather than mutating it in
-- place. So a second setup() call in the same session is silently ignored
-- unless we force everything to be re-required first.
local function reload_vague()
  for name in pairs(package.loaded) do
    if name:match('^vague') then
      package.loaded[name] = nil
    end
  end
  return require('vague')
end

local function apply()
  local vague = reload_vague()
  vague.setup({
    transparent = state.transparent, -- If true, background is not set
    bold = true, -- Disable bold globally
    italic = true, -- Disable italic globally
    colors = { visual = '#4a5568' },
    on_highlights = function(highlights)
      -- Default Comment color (#606079) has too little contrast against bg; lighten it.
      highlights.Comment = { fg = '#8a8aab', italic = true }
    end,
  })
  vim.cmd.colorscheme('vague')
end

apply()

vim.keymap.set('n', '<leader>tt', function()
  state.transparent = not state.transparent
  apply()
end, { desc = 'Toggle colorscheme transparency' })

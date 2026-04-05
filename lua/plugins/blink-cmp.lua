vim.pack.add({
 { src = 'https://github.com/saghen/blink.cmp', version = 'v1.8.0' }
})

require 'blink.cmp'.setup({

-- build = 'cargo build --release',
 fuzzy = { implementation = "lua" },

 keymap = { preset = 'default' },
 appearance = {
  use_nvim_cmp_as_default = false,
  nerd_font_variant = 'mono'
 },
 signature = { enabled = true}
})


vim.pack.add({
 { src = 'https://github.com/saghen/blink.cmp', version = 'v1.8.0' }
})

require 'blink.cmp'.setup({

 build = 'cargo build --release',

 keymap = { preset = 'default' },
 appearance = {
  -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
  -- Adjusts spacing to ensure icons are aligned
  use_nvim_cmp_as_default = false,
  nerd_font_variant = 'mono'
 },
 signature = { enabled = true}
})


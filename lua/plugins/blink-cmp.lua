vim.pack.add({ 'https://github.com/saghen/blink.cmp'})

require 'blink.cmp'.setup({
    fuzzy = { implementation = "prefer_rust_with_warning" },

    keymap = { preset = 'default' },
    appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = 'mono'
    },
    signature = { enabled = true }
})

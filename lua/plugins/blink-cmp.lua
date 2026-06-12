vim.pack.add({
    {
        src='https://github.com/saghen/blink.cmp',
        version = "v1"
    }
})

require 'blink.cmp'.setup({
    fuzzy = { implementation = "prefer_rust" },

    keymap = { preset = 'default' },
    appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = 'mono'
    },
    signature = { enabled = true }
})

local auto = vim.api.nvim_create_autocmd

auto('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

auto('FileType', {
    group = vim.api.nvim_create_augroup('no_auto_comment', {}),
    callback = function()
        vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
    end,
})


auto('VimResized', { command = 'wincmd =' })
auto('FileType', { pattern = 'help', command = 'wincmd L', })

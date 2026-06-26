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


auto('BufLeave', {
    desc = 'Save the buffer being left when switching buffers',
    group = vim.api.nvim_create_augroup('save_on_buf_leave', {}),
    callback = function(args)
        local buf = args.buf
        if vim.bo[buf].buftype ~= '' then return end
        if not vim.bo[buf].modifiable then return end
        if not vim.bo[buf].modified then return end
        if vim.api.nvim_buf_get_name(buf) == '' then return end

        vim.api.nvim_buf_call(buf, function()
            vim.cmd('silent! update')
        end)
    end,
})

auto('VimResized', { command = 'wincmd =' })
auto('FileType', { pattern = 'help', command = 'wincmd L', })

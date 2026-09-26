local auto = vim.api.nvim_create_autocmd

-- Restore cursor to file position in previous editing session
auto("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			-- defer centering slightly so it's applied after render
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})


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

auto('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
        end
    end,
    })

vim.cmd("set completeopt+=noselect")

auto('FileType', {
    desc = 'Start treesitter highlighting when a parser is available',
    group = vim.api.nvim_create_augroup('treesitter_start', {}),
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

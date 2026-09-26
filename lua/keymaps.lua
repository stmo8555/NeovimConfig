local set = vim.keymap.set

-- Disable Ctrl+u in insert mode
set('i', '<C-u>', '<Nop>', { silent = true, desc = 'Disable insert-mode delete to line start' })
set('n', '<Esc>', '<cmd>nohlsearch<CR>', { silent = true, desc = 'Clear search highlight' })

-- maybe remove
set("n", "<C-j>", function() vim.fn.append(vim.fn.line("."), "") end, { desc = "Insert blank line below" })
set("n", "<C-k>", function() vim.fn.append(vim.fn.line(".") - 1, "") end, { desc = "Insert blank line above" })

set('n', '<Space>', '<Nop>', { silent = true, desc = 'Disable Space key' })
set('v', '<Space>', '<Nop>', { silent = true, desc = 'Disable Space key' })

set('n', '<leader>o', function()
    vim.cmd.update()

    local config = vim.fn.stdpath('config')
    local config_lua = vim.fs.normalize(config .. '/lua')

    for _, path in ipairs(vim.fn.globpath(config_lua, '**/*.lua', false, true)) do
        local module = path:sub(#config_lua + 2, -5):gsub('/', '.')
        package.loaded[module] = nil

        if vim.endswith(module, '.init') then
            package.loaded[module:sub(1, -6)] = nil
        end
    end

    vim.cmd.source(config .. '/init.lua')
    vim.api.nvim_echo({ { 'Sourced config' } }, false, {})
end, { silent = true, desc = 'Reload Neovim configuration' })

set('n', '<leader>w', ':write<CR>', { silent = true, desc = 'Write current buffer' })
set('n', '<leader>q', ':q<CR>', { silent = true, desc = 'Quit current window' })

set('i', 'jj', '<Esc>', { silent = true, desc = 'Exit insert mode' })
set('n', '<C-q>', '@q', { silent = true, desc = 'Replay q macro' })

set({ 'n', 'v', 'x' }, 'D', '"_d', { silent = true, desc = 'Delete without yanking' })

set('n', '<C-Left>', ':vertical resize -5<CR>', { silent = true, desc = 'Decrease window width' })
set('n', '<C-Right>', ':vertical resize +5<CR>', { silent = true, desc = 'Increase window width' })

set("n", "grn", function() require("plugins.rename_float").rename() end, { desc = "LSP rename float" })

set('n', '<leader>lf', vim.lsp.buf.format, { desc = 'Format buffer' })

set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor" })
set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center cursor" })

set("n", "n", "nzzzv", { desc = "Next search result and center cursor" })
set("n", "N", "Nzzzv", { desc = "Previous search result and center cursor" })

vim.keymap.set('n', 'gz', function()
    if vim.g.pane_zoomed then
        vim.cmd('wincmd =')
        vim.g.pane_zoomed = false
    else
        vim.cmd('wincmd |')
        vim.g.pane_zoomed = true
    end
end, { desc = 'Toggle window zoom' })

vim.keymap.set("n", "<leader>de", function()
    vim.diagnostic.open_float(nil, {
        scope = "line",
        focus = true,
        border = "rounded",
        source = true,
    })
end, { desc = "Show diagnostic details" })

vim.keymap.set("n", "<leader>dd", function()
	vim.diagnostic.setqflist()
	vim.cmd("copen")
end, { silent = true })

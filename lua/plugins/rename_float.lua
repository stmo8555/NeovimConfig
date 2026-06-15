local M = {}

function M.rename()
    local source_win = vim.api.nvim_get_current_win()
    local old_name = vim.fn.expand("<cword>")
    local buf = vim.api.nvim_create_buf(false, true)

    vim.bo[buf].buftype = "acwrite"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false


    vim.api.nvim_buf_set_name(buf, "rename://" .. old_name)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { old_name })

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "cursor",
        width = math.max(vim.fn.strdisplaywidth(old_name) + 4, math.floor(vim.o.columns / 2)),
        height = 1,
        row = 1,
        col = 0,
        style = "minimal",
    })

    vim.wo[win].wrap = false
    vim.wo[win].sidescrolloff = 0

    local function close()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end

    vim.keymap.set("n", "q", close, { buffer = buf, silent = true })
    vim.keymap.set("n", "<Esc>", close, { buffer = buf, silent = true })
    vim.keymap.set("n", "<CR>", "<cmd>write<CR>", { buffer = buf, silent = true })
    vim.keymap.set("i", "<CR>", "<Nop>", { buffer = buf, silent = true })

    vim.api.nvim_create_autocmd("BufWriteCmd", {
        buffer = buf,
        callback = function()
            local new_name = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]

            vim.bo[buf].modified = false
            close()

            if new_name and new_name ~= "" and new_name ~= old_name then
                vim.api.nvim_set_current_win(source_win)
                vim.lsp.buf.rename(new_name)
            end
        end,
    })
end

return M

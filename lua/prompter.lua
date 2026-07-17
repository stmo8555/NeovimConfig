local function prompt_for_note(ref)
    local source_win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(false, true)

    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].undofile = false

    vim.api.nvim_set_hl(0, "PrompterNormal", { fg = "#cdcdcd", bg = "#1c1c24" })
    vim.api.nvim_set_hl(0, "PrompterBorder", { fg = "#606079", bg = "NONE" })
    vim.api.nvim_set_hl(0, "PrompterTitle", { fg = "#b4d4cf", bg = "NONE", bold = true })
    vim.api.nvim_set_hl(0, "PrompterFooter", { fg = "#606079", bg = "NONE", italic = true })

    local width = math.min(math.max(44, math.floor(vim.o.columns * 0.52)), 72, vim.o.columns - 4)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = 4,
        row = math.floor((vim.o.lines - 6) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
        title = " Prompt ",
        title_pos = "left",
        footer = " <Esc><Enter> copy | q cancel ",
        footer_pos = "right",
    })

    vim.wo[win].wrap = true
    vim.wo[win].winhighlight = table.concat({
        "Normal:PrompterNormal",
        "EndOfBuffer:PrompterNormal",
        "FloatBorder:PrompterBorder",
        "FloatTitle:PrompterTitle",
        "FloatFooter:PrompterFooter",
    }, ",")

    local function close()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
        if vim.api.nvim_win_is_valid(source_win) then
            vim.api.nvim_set_current_win(source_win)
        end
    end

    local function submit()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local note = table.concat(lines, "\n")
        close()
        if vim.iter(lines):any(function(line)
            return line ~= ""
        end) then
            ref = ref .. " " .. note
        end
        vim.fn.setreg("+", ref)
        vim.notify("Copied: " .. ref)
    end

    vim.keymap.set("n", "<CR>", submit, { buffer = buf, silent = true })
    vim.keymap.set("n", "q", close, { buffer = buf, silent = true })
    vim.cmd("startinsert")
end

-- Copy file path / selection reference for pasting into AI chats
local function copy_ref(opts)
    local path = vim.fn.expand("%:.")
    local ref = path

    if opts.visual then
        local start_line = vim.fn.line("v")
        local end_line = vim.fn.line(".")
        if start_line > end_line then
            start_line, end_line = end_line, start_line
        end
        ref = path .. ":" .. start_line .. ":" .. end_line
        vim.cmd("normal! <Esc>")
    end

    prompt_for_note(ref)
end

-- normal mode: copy just the file path
vim.keymap.set("n", "<leader>cp", function()
    copy_ref({})
end, { desc = "Copy file path" })

-- visual mode: copy the file path plus the selected line range
vim.keymap.set("v", "<leader>cp", function()
    copy_ref({ visual = true })
end, { desc = "Copy file path with line range" })

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

    vim.keymap.set("n", "<CR>", submit, { buffer = buf, silent = true, desc = "Copy prompt reference" })
    vim.keymap.set("n", "q", close, { buffer = buf, silent = true, desc = "Cancel prompt" })
    vim.cmd("startinsert")
end

-- Copy file path / selection reference for pasting into AI chats
local function copy_ref(opts)
    local path = vim.fn.expand(opts.full_path and "%:p" or "%:.")
    local ref = path

    if opts.visual then
        local start_line = vim.fn.line("v")
        local end_line = vim.fn.line(".")
        if start_line > end_line then
            start_line, end_line = end_line, start_line
        end
        ref = path .. ":" .. start_line .. ":" .. end_line
        vim.cmd("normal! \27")
    end

    prompt_for_note(ref)
end

-- normal mode: copy the relative file path
vim.keymap.set("n", "<leader>cp", function()
    copy_ref({})
end, { desc = "Copy relative file path" })

-- visual mode: copy the relative file path plus the selected line range
vim.keymap.set("v", "<leader>cp", function()
    copy_ref({ visual = true })
end, { desc = "Copy relative file path with line range" })

-- normal mode: copy the full file path
vim.keymap.set("n", "<leader>cP", function()
    copy_ref({ full_path = true })
end, { desc = "Copy full file path" })

-- visual mode: copy the full file path plus the selected line range
vim.keymap.set("v", "<leader>cP", function()
    copy_ref({ visual = true, full_path = true })
end, { desc = "Copy full file path with line range" })

local QUICK_ANSWER_SYSTEM_PROMPT = table.concat({
    "You are a fast, lightweight assistant invoked from within a Neovim keymap,",
    "used for quick in-editor questions so the user does not have to jump to",
    "another terminal or browser.",
    "Only handle tasks that are simple and can be answered or solved quickly:",
    "short factual questions, small mechanical fixes confined to the single file",
    "given in the prompt, quick explanations, trivial syntax lookups, etc.",
    "Read tool calls are always pre-approved in this session -- call Read",
    "directly, never ask the user to grant read permission.",
    "Never edit or write files yourself; just explain the answer or solution",
    "directly in your reply as plain text, not a formal plan.",
    "If your answer includes a concrete, mechanical fix, end your reply with",
    "one extra line in exactly this format: <relative-file-path>[:start_line:end_line]",
    "<imperative instruction of the fix> -- the same reference format produced",
    "by this editor's file-path-copy keymap -- so the user can reuse that line",
    "directly as the prompt for a separate fix assistant.",
    "If the request requires changes spanning multiple files, deep investigation,",
    "running tests, or any non-trivial reasoning, do not attempt it.",
    "Instead, respond with exactly: \"Use claude code instead\"",
}, " ")

local QUICK_FIX_SYSTEM_PROMPT = table.concat({
    "You are a fast, lightweight assistant invoked from within a Neovim keymap,",
    "used to apply quick, safe, mechanical fixes without the user leaving the editor.",
    "Only handle small mechanical fixes confined to the single file given in the",
    "prompt (e.g. renames, removing a parameter and updating its call sites,",
    "trivial syntax corrections, etc.).",
    "Read tool calls are always pre-approved in this session -- call Read",
    "directly, never ask the user to grant read permission.",
    "Apply the fix directly with your file-editing tools; do not just describe it.",
    "If the request requires changes spanning multiple files, deep investigation,",
    "running tests, or any non-trivial reasoning, do not attempt it and make no",
    "edits. Instead, respond with exactly: \"Use claude code instead\"",
}, " ")

local function ask_claude(permission_mode, system_prompt)
    local q = vim.trim(vim.fn.getreg("+"))
    local models = { "haiku", "opus", "sonnet", "fable" }
    vim.cmd("vsplit")
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, buf)
    vim.fn.jobstart({
        "claude",
        "-p",
        q,
        "--permission-mode",
        permission_mode,
        "--system-prompt",
        system_prompt,
        "--model",
        models[1],
    }, { term = true })
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
end


vim.keymap.set("n", "<leader>ca", function()
    ask_claude("default", QUICK_ANSWER_SYSTEM_PROMPT)
end, { desc = "Ask Claude about clipboard" })

vim.keymap.set("n", "<leader>cf", function()
    ask_claude("acceptEdits", QUICK_FIX_SYSTEM_PROMPT)
end, { desc = "Ask Claude to fix clipboard" })

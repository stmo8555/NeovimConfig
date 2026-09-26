-- Treesitter text objects from queries/<lang>/textobjects.scm (no plugin needed)

-- Smallest node tagged with `capture` that contains the cursor
local function find_node(capture)
    local buf = vim.api.nvim_get_current_buf()
    local ok, parser = pcall(vim.treesitter.get_parser, buf)
    if not ok or not parser then return end

    local query = vim.treesitter.query.get(parser:lang(), 'textobjects')
    if not query then return end

    local root = parser:parse()[1]:root()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row = row - 1

    local best, best_len
    for id, node in query:iter_captures(root, buf) do
        if query.captures[id] == capture and vim.treesitter.is_in_node_range(node, row, col) then
            local _, _, start_byte, _, _, end_byte = node:range(true)
            local len = end_byte - start_byte
            if not best_len or len < best_len then
                best, best_len = node, len
            end
        end
    end
    return best
end

local function select(capture)
    local node = find_node(capture)
    if not node then return end

    local sr, sc, er, ec = node:range()
    -- node ranges are end-exclusive; step back to the last character
    if ec == 0 then
        er = er - 1
        ec = math.max(#vim.api.nvim_buf_get_lines(0, er, er + 1, true)[1] - 1, 0)
    else
        ec = ec - 1
    end

    if vim.api.nvim_get_mode().mode:match('^[vV\22]') then
        vim.cmd('normal! \27')
    end
    vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
    vim.cmd('normal! v')
    vim.api.nvim_win_set_cursor(0, { er + 1, ec })
end

local objects = {
    af = 'function.outer',
    ['if'] = 'function.inner',
    ai = 'block.outer',
    ii = 'block.inner',
}

for lhs, capture in pairs(objects) do
    vim.keymap.set({ 'x', 'o' }, lhs, function() select(capture) end,
        { desc = 'Treesitter ' .. capture })
end

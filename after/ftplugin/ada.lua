-- The bundled Ada ftplugin maps <Leader>al / <Leader>aj in insert mode,
-- which with leader = space makes every typed space wait for timeoutlen.
for _, lhs in ipairs({ '<leader>al', '<leader>aj' }) do
    pcall(vim.keymap.del, 'i', lhs, { buffer = 0 })
end

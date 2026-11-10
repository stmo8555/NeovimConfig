-- Move the current line or visual selection up/down with Alt-j/Alt-k

vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move Line Down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move Line Up" })
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move Line Down" })
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move Line Up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move Selection Down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move Selection Up" })

vim.g.netrw_banner = 0
vim.g.netrw_altfile = 1 -- netrw buffers never become the alternate file

vim.keymap.set("n", "<leader>e", function()
	if vim.bo.filetype == "netrw" then return vim.cmd("buffer #") end
	local name = vim.fn.expand("%:t")
	vim.cmd("Explore")
	vim.fn.search("^\\V" .. vim.fn.escape(name, "\\") .. "\\[*@=|]\\?\\$", "cw")
end, { desc = "Toggle netrw in file's directory" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function()
		vim.keymap.set("n", "<C-c>", "<cmd>buffer #<cr>", { buffer = true })
	end,
})

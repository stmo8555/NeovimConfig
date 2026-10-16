local ignore_patterns = {
	"node_modules",
	"%.git",
	"%.cache",
	"dist",
	"build",
	"%.tmp",
	"%.log",
}

function _G.native_find(text, _)
	local files = vim.fn.glob("**/*", true, true)
	local result = {}
	for _, f in ipairs(files) do
		if vim.fn.isdirectory(f) == 0 then
			local skip = false
			for _, pat in ipairs(ignore_patterns) do
				if f:match(pat) then
					skip = true
					break
				end
			end
			if not skip then
				result[#result + 1] = f
			end
		end
	end
	return vim.fn.matchfuzzy(result, text)
end
vim.opt.findfunc = "v:lua.native_find"


-- Fuzzy file picker: lists every project file, filters as you type
local skip_dirs = {
	[".git"] = true,
	["node_modules"] = true,
	[".cache"] = true,
	["dist"] = true,
	["build"] = true,
}

local function list_files()
	local files = {}
	for name, type in vim.fs.dir(".", {
		depth = math.huge,
		skip = function(dir) return not skip_dirs[vim.fs.basename(dir)] end,
	}) do
		if type == "file" then
			files[#files + 1] = name
		end
	end
	table.sort(files)
	return files
end

local function pick_files()
	local files = list_files()
	local max_results = 200
	local width = math.floor(vim.o.columns * 0.6)
	local height = math.floor(vim.o.lines * 0.6)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local res_buf = vim.api.nvim_create_buf(false, true)
	local res_win = vim.api.nvim_open_win(res_buf, false, {
		relative = "editor", width = width, height = height - 3,
		row = row + 3, col = col, style = "minimal", border = "rounded",
		title = " Files ", focusable = false,
	})
	vim.wo[res_win].cursorline = true

	local in_buf = vim.api.nvim_create_buf(false, true)
	local in_win = vim.api.nvim_open_win(in_buf, true, {
		relative = "editor", width = width, height = 1,
		row = row, col = col, style = "minimal", border = "rounded",
		title = " Find file ",
	})

	local matches, selected = {}, 1

	local function render()
		local query = vim.api.nvim_get_current_line()
		if query == "" then
			matches = vim.list_slice(files, 1, max_results)
		else
			matches = vim.fn.matchfuzzy(files, query, { limit = max_results })
		end
		selected = 1
		vim.api.nvim_buf_set_lines(res_buf, 0, -1, false, matches)
		vim.api.nvim_win_set_config(res_win, {
			title = (" Files %d/%d "):format(#matches, #files),
		})
		if #matches > 0 then
			vim.api.nvim_win_set_cursor(res_win, { 1, 0 })
		end
	end

	local function move(delta)
		if #matches == 0 then return end
		selected = (selected - 1 + delta) % #matches + 1
		vim.api.nvim_win_set_cursor(res_win, { selected, 0 })
	end

	local function close()
		vim.cmd.stopinsert()
		pcall(vim.api.nvim_win_close, in_win, true)
		pcall(vim.api.nvim_win_close, res_win, true)
		pcall(vim.api.nvim_buf_delete, in_buf, { force = true })
		pcall(vim.api.nvim_buf_delete, res_buf, { force = true })
	end

	local function open()
		local file = matches[selected]
		close()
		if file then
			vim.cmd.edit(vim.fn.fnameescape(file))
		end
	end

	vim.api.nvim_create_autocmd({ "TextChangedI", "TextChanged" }, { buffer = in_buf, callback = render })
	vim.api.nvim_create_autocmd("WinLeave", { buffer = in_buf, once = true, callback = close })

	local opts = { buffer = in_buf, nowait = true }
	vim.keymap.set("i", "<CR>", open, opts)
	vim.keymap.set("i", "<C-n>", function() move(1) end, opts)
	vim.keymap.set("i", "<Down>", function() move(1) end, opts)
	vim.keymap.set("i", "<C-p>", function() move(-1) end, opts)
	vim.keymap.set("i", "<Up>", function() move(-1) end, opts)
	vim.keymap.set({ "i", "n" }, "<Esc>", close, opts)
	vim.keymap.set({ "i", "n" }, "<C-c>", close, opts)

	render()
	vim.cmd.startinsert()
end

vim.keymap.set("n", "<leader>ff", pick_files, { desc = "Fuzzy find project file" })

return { list_files = list_files }

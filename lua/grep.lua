local has_rg = vim.fn.executable("rg") == 1
if has_rg then
	-- Unquoted glob so it works in both sh and cmd.exe
	vim.opt.grepprg = "rg --vimgrep --smart-case --hidden --glob=!.git"
	vim.opt.grepformat = "%f:%l:%c:%m"
end

-- Built-in search for machines without ripgrep (e.g. locked-down Windows).
-- Pattern is a Vim regex, smart-case like rg.
local max_file_size = 1024 * 1024

local function lua_grep(pattern)
	local case = (pattern:find("%u") and "\\C" or "\\c")
	local ok, regex = pcall(vim.regex, case .. pattern)
	if not ok then
		vim.notify("Invalid pattern: " .. pattern, vim.log.levels.ERROR)
		return false
	end

	local items = {}
	for _, file in ipairs(require("find").list_files()) do
		local f = io.open(file, "rb")
		if f then
			local content = f:read(max_file_size + 1)
			f:close()
			-- Skip big and binary files
			if content and #content <= max_file_size and not content:find("\0", 1, true) then
				local lnum = 0
				for line in (content .. "\n"):gmatch("(.-)\r?\n") do
					lnum = lnum + 1
					local col = regex:match_str(line)
					if col then
						items[#items + 1] = { filename = file, lnum = lnum, col = col + 1, text = line }
					end
				end
			end
		end
	end
	vim.fn.setqflist({}, " ", { title = "Grep: " .. pattern, items = items })
	return true
end

local function grep(pattern)
	if not pattern or pattern == "" then return end
	if has_rg then
		vim.cmd("silent grep! " .. vim.fn.shellescape(pattern, true))
	elseif not lua_grep(pattern) then
		return
	end
	vim.cmd("cwindow")
	if #vim.fn.getqflist() == 0 then
		vim.notify("No matches for " .. pattern, vim.log.levels.WARN)
	end
end

vim.keymap.set("n", "<leader>fg", function()
	vim.ui.input({ prompt = "Grep: " }, grep)
end, { silent = true, desc = "Grep project" })

vim.keymap.set("n", "<leader>fw", function()
	grep(vim.fn.expand("<cword>"))
end, { silent = true, desc = "Grep word under cursor" })

-- lsp
vim.lsp.enable({ "lua_ls", "ada_ls" })
vim.diagnostic.config({ virtual_text = true })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client ~= nil and client:supports_method("textDocument/completion") then
			-- ALS only triggers on . , ' ( so also trigger on identifier characters
			if client.name == "ada_ls" then
				local triggers = client.server_capabilities.completionProvider.triggerCharacters
				for c in ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"):gmatch(".") do
					table.insert(triggers, c)
				end
			end
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})

vim.cmd("set completeopt+=noselect,fuzzy")

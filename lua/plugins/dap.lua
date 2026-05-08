vim.pack.add({
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/leoluz/nvim-dap-go",
    "https://github.com/igorlfs/nvim-dap-view",
    "https://github.com/theHamsta/nvim-dap-virtual-text",
})

require("dap-go").setup()
require("nvim-dap-virtual-text").setup()

vim.keymap.set("n", "<leader>bb", "<cmd>DapToggleBreakpoint<cr>")
vim.keymap.set("n", "<leader>bt", "<cmd>DapViewToggle<cr>")
vim.keymap.set("n", "<leader>bc", "<cmd>DapContinue<cr>")
vim.keymap.set("n", "<leader>bw", "<cmd>DapViewWatch<cr>")

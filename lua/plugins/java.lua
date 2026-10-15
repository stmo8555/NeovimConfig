vim.pack.add({
    "https://codeberg.org/mfussenegger/nvim-jdtls",
    "https://github.com/JavaHello/spring-boot.nvim",
})

local lsp = require "plugins.lsp"

require "nvim-treesitter".install({ "java" })

lsp.mason_install({
    "jdtls",
    "vscode-spring-boot-tools",
})

vim.lsp.config.thymeleaf_ls = {
    cmd = { "thymeleaf_ls" },
    filetypes = { "html" },
    root_markers = { "pom.xml", "build.gradle", "build.gradle.kts", ".git" },
}

vim.lsp.enable("thymeleaf_ls")

require('spring_boot').setup({
    server = {
        capabilities = lsp.capabilities,
    },
})

local lombok = vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar"

vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
        require("jdtls").start_or_attach({
            cmd = { "jdtls", "--jvm-arg=-javaagent:" .. lombok },
            root_dir = vim.fs.root(0, { "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts", ".git" }),
            capabilities = lsp.capabilities,
            init_options = {
                bundles = require("spring_boot").java_extensions(),
            },
        })
    end,
})

-- jdtls fires nonstop $/progress updates while indexing/building; mini.notify
-- reads its lsp_progress.enable setting live on every event, so just flip it
-- off while focused on a java buffer instead of touching LSP handlers.
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(args)
        local ok, notify = pcall(require, "mini.notify")
        if ok then
            notify.config.lsp_progress.enable = vim.bo[args.buf].filetype ~= "java"
        end
    end,
})

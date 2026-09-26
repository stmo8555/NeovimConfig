---@brief
---
--- https://github.com/AdaCore/ada_language_server
---
--- Installation instructions can be found [here](https://github.com/AdaCore/ada_language_server#Install).
---
--- Workspace-specific [settings](https://github.com/AdaCore/ada_language_server/blob/master/doc/settings.md) such as `projectFile` can be provided in a `.als.json` file at the root of the workspace.
--- Alternatively, configuration may be passed as a "settings" object to `vim.lsp.config('ada_ls', {})`:
---
--- ```lua
--- vim.lsp.config('ada_ls', {
---     settings = {
---       ada = {
---         projectFile = "project.gpr";
---         scenarioVariables = { ... };
---       }
---     }
--- })
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'ada_language_server' },
  filetypes = { 'ada' },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, function(name)
      return name == 'Makefile' or name == '.git' or name == 'alire.toml'
        or name:match('%.gpr$') ~= nil or name:match('%.adc$') ~= nil
    end))
  end,
}

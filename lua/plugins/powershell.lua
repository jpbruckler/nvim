-- powershell.nvim starts its own PowerShell Editor Services client, so
-- powershell_es is NOT listed in lsp.lua's vim.lsp.enable().
-- Buffer-local keymaps live in ftplugin/ps1.lua.
require("powershell").setup({
  bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
})

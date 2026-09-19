-- PowerShell buffers: powershell.nvim's Extension Terminal shares the LSP session,
-- so code evaluated here sees the same state as the language server.

vim.keymap.set("n", "<leader>lt", function()
  require("powershell").toggle_term()
end, { buffer = true, desc = "Toggle PowerShell terminal" })

vim.keymap.set("n", "<leader>lD", function()
  require("powershell").toggle_debug_term()
end, { buffer = true, desc = "Toggle PowerShell debug terminal" })

vim.keymap.set({ "n", "x" }, "g=", function()
  return require("powershell").eval_operator()
end, { buffer = true, expr = true, desc = "Eval in PowerShell terminal" })

-- g== evaluates the current line, like builtin dd/cc
vim.keymap.set("n", "g==", function()
  return require("powershell").eval_operator() .. "_"
end, { buffer = true, expr = true, desc = "Eval current line in PowerShell terminal" })

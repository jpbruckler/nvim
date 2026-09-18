-- Enable PowerShell Extension Terminal
vim.keymap.set("n", "<leader>lt", function() require("powershell").toggle_term() end)

-- Enable PowerShell Debug Terminal
vim.keymap.set("n", "<leader>ld", function() require("powershell").toggle_debug_term() end)

vim.keymap.set({ "n", "x" }, "g=", function() return require("powershell").eval_operator() end, { expr = true })

-- to make `g==` operate in the current like just like builtin `dd` or `cc`
vim.keymap.set({ "n" }, "g==", function() return require("powershell").eval_operator() .. "_" end, { expr = true })

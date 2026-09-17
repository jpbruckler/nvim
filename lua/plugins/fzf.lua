-- ===============================================
-- FzF Lua
-- ===============================================
local fzflua = require("fzf-lua")
fzflua.setup()

-- keymaps
vim.keymap.set("n", "<leader>ff", function() fzflua.files() end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", function() fzflua.live_grep() end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", function() fzflua.buffers() end, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", function() fzflua.help_tags() end, { desc = "Search help tags" })
vim.keymap.set("n", "<leader>fx", function() fzflua.diagnostics_document() end, { desc = "Diagnostics (current buffer)" })
vim.keymap.set("n", "<leader>fX", function() fzflua.diagnostics_workspace() end, { desc = "Diagnostics (workspace)" })
vim.keymap.set("n", "<leader>fk", function() fzflua.keymaps() end, { desc = "Search keymaps" })

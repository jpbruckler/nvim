vim.g.mapleader = " " -- space for leader
vim.g.maplocalleader = " " -- space for localleader


vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })

-- Ctrl + C to get out of insert mode and remove highlights
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "<C-c>", ":nohl<CR>", { desc = "Clear search highlighting", silent = true })

-- move lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })

-- make indents more intuitive
vim.keymap.set("v", "<", "<gv", { desc = "Unindent and keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and keep selection" })

-- join lines without jumping the cursor
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving the cursor" })

-- ctrl + u and ctrl + d for moving down the bbuffer with cursor centered
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move down in buffer with cursor centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move up in buffer with cursor centered" })

-- search result navigating with cursor centered
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word cursor is on globally" })
vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "makes file executable" })

vim.keymap.set("n", "<leader>re", "<cmd>restart<cr>", { desc = "Restart config :restart)" })


vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })


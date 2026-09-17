vim.g.mapleader = " " -- space for leader
-- vim.g.maplocalleader = " " -- space for localleader

vim.keymap.set({ "n", "x" }, "s", "<Nop>", { desc = "Disable s (reserved for mini.surround)" })

-- Replaced by mini.move
-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll half page up (centered)" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

vim.keymap.set("v", "<", "<gv", { silent = true, desc = "Unindent and keep selection" })
vim.keymap.set("v", ">", ">gv", { silent = true, desc = "Indent and keep selection" })

-- leader d delete wont remember as yanked/clipboard when delete pasting
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("n", "<C-c>", ":nohl<CR>", { silent = true, desc = "Clear search highlight" })

-- format built in
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format buffer (LSP)" })

-- prevent x delete from registering when next paste
vim.keymap.set("n", "x", '"_x', { silent = true, desc = "Delete character without yanking" })

-- Replace the word cursor is on globally
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor (whole file)" })
-- Executes shell command from in here making file executable
vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file executable" })

-- tab stuff
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

--split management
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equalize split sizes" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Copy filepath to the clipboard
vim.keymap.set("n", "<leader>fp", function()
    local filePath = vim.fn.expand("%:~")
    vim.fn.setreg("+", filePath)
    print("File path copied to clipboard: " .. filePath)
end, { desc = "Copy file path to clipboard" })

-- restart 
vim.keymap.set("n", "<leader>re", "<cmd>restart<cr>", {
    desc = "Restart Neovim",
})

vim.keymap.set("n", "<leader>lr", function()
    vim.cmd("lsp restart")
    vim.notify("LSP restarted", vim.log.levels.INFO)
end, { desc = "Restart LSP" })

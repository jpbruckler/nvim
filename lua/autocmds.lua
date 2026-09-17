local group = vim.api.nvim_create_augroup("UserAutocmds", { clear = true })

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    desc = "Highlight yanked text",
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Markdown: treat hyphenated-words as a single word (w, *, ciw)
vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "markdown",
    desc = "Include - in iskeyword for markdown",
    callback = function()
        vim.opt_local.iskeyword:append("-")
    end,
})

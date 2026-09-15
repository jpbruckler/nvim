vim.pack.add({
    "https://github.com/bluz71/vim-moonfly-colors",
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/rafamadriz/friendly-snippets",
    "https://www.github.com/ibhagwan/fzf-lua",
})

-- =============================================== 
-- Mini Nvim
-- =============================================== 
require("mini.ai").setup()
require("mini.move").setup({})
require("mini.surround").setup({})
require("mini.cursorword").setup({})
require("mini.indentscope").setup({})
require("mini.pairs").setup({})
require("mini.trailspace").setup({})
require("mini.bufremove").setup({})
require("mini.icons").setup({})
require("mini.git").setup({})


require("mini.comment").setup({
	options = {
		custom_commentstring = function()
			return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
		end,
	},
})

 
-------------------------------------------------- 
-- mini files
-------------------------------------------------- 
require("mini.files").setup({
    mappings = {
        go_in = "<CR>",
        go_in_plus = "L",
        go_out = "_",
        go_out_plus = "H",
    },
})

vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" })
vim.keymap.set("n", "<leader>-", function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    MiniFiles.reveal_cwd()
end, { desc = "Toggle into currently opened file directory" })

-- mini notify --
require("mini.notify").setup({
    content = {
        format = function(notif)
            return notif.msg
        end,
    },
})

-------------------------------------------------- 
-- mini picker
-------------------------------------------------- 
local MiniPick = require("mini.pick")
MiniPick.setup()

-- keymaps
vim.keymap.set("n", "<leader>pf", function() MiniPick.builtin.files() end, { desc = "Mini file picker" })
vim.keymap.set("n", "<leader>ps", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end, { desc = "Grep/search word" })
vim.keymap.set("n", "<leader>vh", function() MiniPick.builtin.help() end, { desc = "Mini Help" })

-------------------------------------------------- 
-- mini extra
-------------------------------------------------- 
local MiniExtra = require("mini.extra")
MiniExtra.setup()

-- keymaps
vim.keymap.set("n", "<leader>xx", function() MiniExtra.pickers.diagnostic() end, { desc = "Mini Picker Diagnostics" })
vim.keymap.set("n", "<leader>pk", function() MiniExtra.pickers.keymaps() end, { desc = 'Search keymaps' })

-- mini completions --
require("mini.completion").setup({
    lsp_completion = {
        auto_setup = true,
    }
})

--- mini snippets ---
local MiniSnippets = require("mini.snippets")
MiniSnippets.setup({
    snippets = {
        MiniSnippets.gen_loader.from_lang(), -- loads friendly-snippets
    },
})
MiniSnippets.start_lsp_server({ match = false })




-- =============================================== 
-- FzF Lua
-- =============================================== 
local fzflua = require("fzf-lua")
fzflua.setup()

-- keymaps
vim.keymap.set("n", "<leader>ff", function() fzflua.files() end, { desc = "FzF Files" })
vim.keymap.set("n", "<leader>fg", function() fzflua.live_grep() end, { desc = "FzF Live Grep" })
vim.keymap.set("n", "<leader>fb", function() fzflua.buffers() end, { desc = "FzF Buffers" })
vim.keymap.set("n", "<leader>fh", function() fzflua.help_tags() end, { desc = "FzF Help Tags" })
vim.keymap.set("n", "<leader>fx", function() fzflua.diagnostics_document() end, { desc = "FzF Diagnostics Document" })
vim.keymap.set("n", "<leader>fX", function() fzflua.diagnostics_workspace() end, { desc = "FzF Diagnostics Workspace" })

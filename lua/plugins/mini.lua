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

--------------------------------------------------
-- mini files
--------------------------------------------------
local mnf = require("mini.files")
mnf.setup({
  mappings = {
    go_in = "<CR>",
    go_in_plus = "L",
    go_out = "_",
    go_out_plus = "H",
  },
})

vim.keymap.set("n", "-", function(...)
  if mnf.close() == nil then mnf.open(...) end
end, { desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>-", function()
  mnf.open(vim.api.nvim_buf_get_name(0), false)
  mnf.reveal_cwd()
end, { desc = "Open file explorer at current file" })

-- mini notify --
require("mini.notify").setup({
  content = {
    format = function(notif)
      return notif.msg
    end,
  },
})

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
    MiniSnippets.gen_loader.from_lang(),     -- loads friendly-snippets
  },
})
MiniSnippets.start_lsp_server({ match = false })

-- shows available keymaps as you type a prefix (e.g. <leader>) — useful
-- given how many custom <leader> mappings this config defines
require("mini.clue").setup({
	triggers = {
		{ mode = "n", keys = "<Leader>" },
		{ mode = "x", keys = "<Leader>" },
		{ mode = "n", keys = "g" },
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },
	},
	clues = {
		require("mini.clue").gen_clues.builtin_completion(),
	},
})

-- restore buffers/window layout per-project on relaunch
require("mini.sessions").setup({})

require("mini.diff").setup({
	view = {
		style = "sign",
		signs = { add = "▎", change = "▎", delete = "▎" },
	},
})

local MiniDiff = require("mini.diff")
vim.keymap.set("n", "]h", function()
	MiniDiff.goto_hunk("next")
end, { desc = "Next git hunk" })
vim.keymap.set("n", "[h", function()
	MiniDiff.goto_hunk("prev")
end, { desc = "Prev git hunk" })
vim.keymap.set("n", "<leader>hs", MiniDiff.operator, { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>hp", function()
	MiniDiff.toggle_overlay()
end, { desc = "Preview diff overlay" })
vim.keymap.set("n", "<leader>hb", function()
	require("mini.git").show_at_cursor()
end, { desc = "Git blame/show" })

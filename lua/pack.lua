vim.pack.add({
    "https://github.com/bluz71/vim-moonfly-colors",
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/nvim-lualine/lualine.nvim",
	"https://www.github.com/ibhagwan/fzf-lua",
	"https://www.github.com/nvim-tree/nvim-tree.lua",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},
	"https://github.com/JoosepAlviste/nvim-ts-context-commentstring",
	-- Language Server Protocols
	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/creativenull/efmls-configs-nvim",
	{
		-- NOTE: blink.cmp v2 is now the actively developed branch (breaking
		-- changes vs v1). Staying pinned to v1 here deliberately for stability.
		-- Revisit this pin when ready to migrate — v2 requires installing
		-- blink.lib as a native dependency outside vim.pack.
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
	"https://github.com/obsidian-nvim/obsidian.nvim",
	"https://github.com/mrcjkb/rustaceanvim",
	"https://github.com/christoomey/vim-tmux-navigator",
})

-- ==============================================
-- mini nvim setup
-- ==============================================
require("mini.ai").setup()
require("mini.comment").setup({
	options = {
		custom_commentstring = function()
			return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
		end,
	},
})
require("mini.move").setup({})
require("mini.surround").setup({})
require("mini.cursorword").setup({})
require("mini.indentscope").setup({})
require("mini.pairs").setup({})
require("mini.trailspace").setup({})
require("mini.bufremove").setup({})
require("mini.icons").setup({})
require("mini.git").setup({})

-- mini files --
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

-- mini cmdline completion --
require("mini.cmdline").setup({
    autocorrect = { enable = false }
})

-- mini clue --
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

-- mini picker --
local MiniPick = require("mini.pick")
MiniPick.setup()

-- keymaps
vim.keymap.set("n", "<leader>pf", function() MiniPick.builtin.files() end, { desc = "Mini file picker" })
vim.keymap.set("n", "<leader>ps", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end, { desc = "Grep/search word" })
vim.keymap.set("n", "<leader>vh", function() MiniPick.builtin.help() end, { desc = "Mini Help" })

-- mini extra --
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
    -- disable empty tabstop indicators
    expand = {
        insert = function(snippet)
            MiniSnippets.default_insert(snippet, { empty_tabstop = "" })
        end,
    },
})
MiniSnippets.start_lsp_server({ match = false })

--- mini diff and fugitive ---
local MiniDiff = require("mini.diff")
MiniDiff.setup({
	source = MiniDiff.gen_source.git({ index = false }),
})

-- keymaps
vim.keymap.set("n", "<leader>gg", "<cmd>tabnew | Git | only<cr>", { desc = "Fugitive Full Page New Tab" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", { desc = "Git diff split", })
vim.keymap.set("n", "]h", function() MiniDiff.goto_hunk("next") end, { desc = "Next git hunk" })
vim.keymap.set("n", "[h", function() MiniDiff.goto_hunk("prev") end, { desc = "Previous git hunk" })
vim.keymap.set("n", "<leader>hs", MiniDiff.operator, { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>hp", function() MiniDiff.toggle_overlay() end, { desc = "Preview diff overlay" })
vim.keymap.set("n", "<leader>hb", function() require("mini.git").show_at_cursor() end, { desc = "Git blame/show" })

-- Obsidian
local function get_notes_path()
  if vim.fn.has("mac") == 1 then
    return vim.fn.expand("~/git/nbx")
  end
end

require("obsidian").setup({
    legacy_commands = false,
    workspaces = { { name = "Notes", path = get_notes_path() } },
    picker = { name = "fzf-lua" },
  })

  vim.keymap.set("n", "<leader>nn", function()
    vim.cmd("Obsidian workspace")
    vim.defer_fn(function()
      vim.cmd("Obsidian new")
    end, 500)
  end, { desc = "New note" })
  vim.keymap.set("n", "<leader>nf", "<cmd>Obsidian quick_switch<cr>", { desc = "Find note" })
  vim.keymap.set("n", "<leader>ns", "<cmd>Obsidian search<cr>",       { desc = "Search notes" })
  vim.keymap.set("n", "<leader>nt", "<cmd>Obsidian today<cr>",        { desc = "Today's daily note" })
  vim.keymap.set("n", "<leader>nw", "<cmd>Obsidian workspace<cr>",    { desc = "Switch workspace" })


-- ==============================================
-- fzf
-- ==============================================
local fzflua = require("fzf-lua")
fzflua.setup()

-- keymaps
vim.keymap.set("n", "<leader>ff", function() fzflua.files() end, { desc = "FzF Files" })
vim.keymap.set("n", "<leader>fg", function() fzflua.live_grep() end, { desc = "FzF Live Grep" })
vim.keymap.set("n", "<leader>fb", function() fzflua.buffers() end, { desc = "FzF Buffers" })
vim.keymap.set("n", "<leader>fh", function() fzflua.help_tags() end, { desc = "FzF Help Tags" })
vim.keymap.set("n", "<leader>fx", function() fzflua.diagnostics_document() end, { desc = "FzF Diagnostics Document" })
vim.keymap.set("n", "<leader>fX", function() fzflua.diagnostics_workspace() end, { desc = "FzF Diagnostics Workspace" })


-- ==============================================
-- Lualine setup
-- ==============================================
require("lualine").setup({
	options = {
		theme = "moonfly",
		icons_enabled = true,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		globalstatus = false, -- keep per-window active/inactive styling
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { { "branch", icon = "\u{e725}" } }, -- nf-dev-git_branch
		lualine_c = { { "filename", path = 0 } },
		lualine_x = {
			function()
				local size = vim.fn.getfsize(vim.fn.expand("%"))
				if size < 0 then
					return ""
				elseif size < 1024 then
					return size .. "B"
				elseif size < 1024 * 1024 then
					return string.format("%.1fK", size / 1024)
				else
					return string.format("%.1fM", size / 1024 / 1024)
				end
			end,
			{ "filetype", icon_only = false },
		},
		lualine_y = { "location" }, -- %l:%c equivalent
		lualine_z = { "progress" }, -- %P equivalent
	},
	inactive_sections = {
		lualine_c = { { "filename", path = 0 } },
		lualine_x = { "filetype" },
	},
})


-- ==============================================
-- Treesitter
-- ==============================================
require("treesitter")
require("lsp")

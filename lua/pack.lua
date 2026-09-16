vim.pack.add({
    "https://github.com/bluz71/vim-moonfly-colors",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/nvim-mini/mini.extra",
   "https://github.com/rafamadriz/friendly-snippets",
    "https://www.github.com/ibhagwan/fzf-lua",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
		build = ":TSUpdate",
	},
  -- Language Server Protocols
	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
  "https://github.com/obsidian-nvim/obsidian.nvim",
})



-- =============================================== 
-- Treesitter Setup
-- =============================================== 
local setup_treesitter = function()
	local treesitter = require("nvim-treesitter")
	treesitter.setup({})
	local ensure_installed = {
		"vim",
		"vimdoc",
		"rust",
		"c",
		"cpp",
		"c_sharp",
		"go",
		"html",
		"css",
		"javascript",
		"json",
		"lua",
		"markdown",
		"python",
		"typescript",
		"vue",
		"svelte",
		"bash",
	}

	local config = require("nvim-treesitter.config")

	local already_installed = config.get_installed()
	local parsers_to_install = {}

	for _, parser in ipairs(ensure_installed) do
		if not vim.tbl_contains(already_installed, parser) then
			table.insert(parsers_to_install, parser)
		end
	end

	if #parsers_to_install > 0 then
		treesitter.install(parsers_to_install)
	end

	local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(args)
			if vim.list_contains(config.get_installed(), vim.treesitter.language.get_lang(args.match)) then
				vim.treesitter.start(args.buf)
			end
		end,
	})
end

setup_treesitter()


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

------------------------------------------------ 
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

require("lualine").setup({
	options = {
		theme = "moonfly", -- melange-nvim ships a dedicated lualine theme
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

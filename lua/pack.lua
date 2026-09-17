vim.pack.add({
  "https://github.com/bluz71/vim-moonfly-colors",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-mini/mini.nvim",
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



-- ===============================================
-- Lualine config
-- ===============================================
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

require("mini.git").setup({})

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

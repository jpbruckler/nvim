-- ===============================================
-- Plugin management (vim.pack)
-- ===============================================

-- Hooks must be registered before vim.pack.add() so they fire on install/update.
-- Rebuild treesitter parsers whenever nvim-treesitter itself updates.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "nvim-treesitter" and ev.data.kind == "update" then
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add({
  "https://github.com/bluz71/vim-moonfly-colors",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/ibhagwan/fzf-lua",
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },
  -- Language Server Protocols
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/obsidian-nvim/obsidian.nvim",
})

-- :PackAdd / :PackDel / :PackUpdate
vim.api.nvim_create_user_command("PackAdd", function(opts)
  vim.pack.add(opts.fargs)
end, { nargs = "+", desc = "Add plugins (:PackAdd user/repo)" })

vim.api.nvim_create_user_command("PackDel", function(opts)
  vim.pack.del(opts.fargs)
end, { nargs = "+", desc = "Delete plugins (:PackDel plugin1 plugin2)" })

vim.api.nvim_create_user_command("PackUpdate", function(opts)
  -- checks if any argument is passed
  if opts.args:match("%S") then
    -- update specific plugins
    local plugins = vim.split(opts.args, "%s+", { trimempty = true })
    -- update only specified plugins
    vim.pack.update(plugins)
  else
    -- update all
    vim.pack.update()
  end
end, { nargs = "*", desc = "Update all plugins or specific ones" })

-- ===============================================
-- Plugin configs (lua/plugins/)
-- ===============================================
require("plugins.treesitter")
require("plugins.mini")
require("plugins.fzf")
require("plugins.lualine")

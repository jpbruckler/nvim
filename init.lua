require("vim._core.ui2").enable({
msg = {
    targets = {
      emsg = "pager",      -- general errors, including "Error detected while processing init.lua"
      lua_error = "pager", -- errors from :lua
    },
  },
})

require("options")
require("autocmds")
require("keymaps")
require("commands")
require("pack")
require("lsp")

vim.cmd.colorscheme("moonfly")

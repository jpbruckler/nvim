-- ===============================================
-- LSP
-- ===============================================
-- nvim-lspconfig supplies ready-made server configs (cmd, filetypes, root markers).
-- vim.lsp.config() only overrides what we need; vim.lsp.enable() turns servers on.
-- Servers are installed with :Mason. mason.setup() puts Mason's bin folder on PATH.

require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = { "powershell_es" }, -- auto-install
    -- powershell.nvim starts powershell_es itself (see plugins/powershell.lua);
    -- letting mason-lspconfig enable it too would start a second client.
    automatic_enable = { exclude = { "powershell_es" } },
})

-- Lua: tell lua_ls this is Neovim's LuaJIT and where the `vim` API lives.
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
            },
        },
    },
})

vim.lsp.enable({
    "lua_ls",        -- Mason: lua-language-server
    "bashls",        -- Mason: bash-language-server (needs Node); add shellcheck for lint diagnostics
    "pyright",       -- Mason: pyright (needs Node)
    "rust_analyzer", -- Mason: rust-analyzer, or `rustup component add rust-analyzer`
    "ruff",          -- Mason: ruff
})

-- Diagnostics: inline messages are off by default since Neovim 0.11.
vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,
    float = { border = "rounded", source = true },
})

-- Neovim already maps K, grn, gra, grr, gri, grt, gO, <C-s>, [d, ]d when a server attaches.
-- These fill the common gaps.
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
    callback = function(ev)
        local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
        end
        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gD", vim.lsp.buf.declaration, "Go to declaration")
        map("<leader>ld", vim.diagnostic.open_float, "Show line diagnostics")
    end,
})

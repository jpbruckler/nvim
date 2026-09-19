# nvim

Personal Neovim config. Plugins are managed with the built-in `vim.pack`, and
versions are pinned in `nvim-pack-lock.json`.

## Layout

```
init.lua                 ui2 messages, then loads the modules below in order
lua/
  options.lua            editor options (only non-defaults)
  autocmds.lua           yank highlight, per-filetype tweaks
  keymaps.lua            mappings that don't depend on a plugin
  terminal.lua           floating terminal (<C-\> toggles, <C-q> leaves terminal mode)
  pack.lua               PackChanged hook, plugin list, :Pack* commands, plugin configs
  lsp.lua                Mason, language servers, diagnostics, LSP keymaps
  plugins/
    treesitter.lua       parser install + highlighting
    mini.lua             mini.nvim modules (files, completion, snippets, diff, clue, ...)
    fzf.lua              fzf-lua + <leader>f* keymaps
    lualine.lua          statusline
    powershell.lua       powershell.nvim (starts its own powershell_es client)
ftplugin/
  ps1.lua                PowerShell keymaps: <leader>lt terminal, g= eval
```

## New machine setup

Step 1 is per-OS; steps 2 onward are the same everywhere.

### 1. Host packages

#### macOS

```sh
xcode-select --install          # C compiler (treesitter parsers), git, make

brew install neovim             # needs 0.12+ (vim.pack, ui2, :restart, :lsp)
brew install tree-sitter-cli    # builds treesitter parsers; must NOT come from npm
brew install fzf ripgrep fd     # fzf-lua (fzf required; rg for live grep, fd for files)
brew install node               # Mason installs pyright and bash-language-server via npm
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh   # Rust toolchain (skip if you don't write Rust)

brew install --cask font-jetbrains-mono-nerd-font   # or any Nerd Font
```

Set your terminal to use the Nerd Font. Without one, the icons from lualine
and mini.icons show up as boxes.

Mason also needs `curl`, `unzip`, `tar` and `gzip`. macOS already has them.

| Package | Needed for |
|---|---|
| Neovim 0.12+ | the whole config |
| git | `vim.pack` (plugin installs), mini.git / mini.diff |
| C compiler + `tree-sitter` CLI (0.26.1+) | nvim-treesitter `main` branch parser builds |
| fzf | fzf-lua (required) |
| ripgrep, fd | fzf-lua live grep / file finding; obsidian.nvim search |
| Node.js | Mason: `pyright`, `bash-language-server` |
| Nerd Font | icons |
| rustup | Rust toolchain; optionally `rust-analyzer` |

#### Windows

```powershell
winget install Neovim.Neovim
winget install Git.Git
winget install Microsoft.PowerShell          # pwsh 7+; 'shell' is set to pwsh in options.lua
winget install BurntSushi.ripgrep.MSVC sharkdp.fd junegunn.fzf
winget install OpenJS.NodeJS.LTS
winget install tree-sitter.tree-sitter       # treesitter parser builds
winget install Rustlang.Rustup              # skip if you don't write Rust
```

Parser builds also need a C compiler: install Visual Studio Build Tools with the
"Desktop development with C++" workload, or `winget install LLVM.LLVM` and use
clang. Install a Nerd Font from <https://nerdfonts.com> and set it in Windows
Terminal.

The config goes in `$env:LOCALAPPDATA\nvim` on Windows:

```powershell
git clone https://github.com/jpbruckler/nvim.git $env:LOCALAPPDATA\nvim
```

#### Arch Linux

```sh
sudo pacman -S neovim git base-devel tree-sitter-cli fzf ripgrep fd nodejs npm rustup
sudo pacman -S wl-clipboard          # or xclip on X11 — needed for clipboard=unnamedplus
sudo pacman -S ttf-jetbrains-mono-nerd   # or any Nerd Font
```


### 2. Clone the config

```sh
git clone https://github.com/jpbruckler/nvim.git ~/.config/nvim
```

### 3. First launch: plugins and parsers

```sh
nvim
```

- `vim.pack` lists the plugins it's about to install from `nvim-pack-lock.json`.
  Confirm the prompt. They install at the exact revisions in the lockfile.
- Treesitter parsers from `lua/plugins/treesitter.lua` start installing in the
  background. If you see build errors, check `tree-sitter --version` and that
  a C compiler is available.
- Run `:restart` once everything has installed.

### 4. Language servers and tools (Mason)

```vim
MasonInstall lua-language-server bash-language-server pyright ruff rust-analyzer shellcheck shfmt
```

| Mason package | Used by | Notes |
|---|---|---|
| `lua-language-server` | `lua_ls` | |
| `bash-language-server` | `bashls` | needs Node |
| `shellcheck` | `bashls` | bashls warnings; without it bashls reports nothing |
| `shfmt` | `bashls` | shell formatting (`<leader>lf`) |
| `pyright` | `pyright` | types, go-to-definition; needs Node |
| `ruff` | `ruff` | Python linting and formatting |
| `rust-analyzer` | `rust_analyzer` | see below |

**rust-analyzer:** install it from Mason **or** with
`rustup component add rust-analyzer`, not both. Mason puts its own bin folder
first on Neovim's PATH, so a Mason copy always wins over the rustup one. The
rustup version stays in step with your toolchain.

### 4b. PowerShell (Windows)

`powershell_es` (PowerShell Editor Services) is installed automatically by
mason-lspconfig on first start; `:Mason` shows the progress. powershell.nvim
starts that server itself, which is why `lsp.lua` doesn't list it in
`vim.lsp.enable()` and mason-lspconfig is told to skip it.

In a `.ps1` buffer:

| Key | Action |
|---|---|
| `<leader>lt` | Toggle the PowerShell Extension Terminal |
| `<leader>lD` | Toggle the debug terminal (needs nvim-dap) |
| `g=` + motion | Evaluate that text in the terminal |
| `g==` | Evaluate the current line |

The Extension Terminal shares the language server's session, so variables you
set there are visible to completion and hover.

### 5. Verify

```sh
nvim --headless +qa    # no output = no startup errors
```

Then inside Neovim:

```vim
:checkhealth vim.pack vim.lsp mason nvim-treesitter
```

Open a Lua, Python, shell and Rust file and check that `:checkhealth vim.lsp`
shows a client attached for each.

## Terminal

`<C-\>` toggles a floating terminal running `'shell'` (pwsh on Windows, `$SHELL`
elsewhere). Toggling hides the window, so the shell keeps running and the
scrollback is preserved. `<C-q>` leaves terminal mode, because the `<C-\>`
mapping shadows the builtin `<C-\><C-n>`.

## Keeping machines in sync

**Updating plugins (on any machine):**

1. `:PackUpdate`. A confirmation buffer opens. Review it, then `:write` to
   apply or `:quit` to discard.
2. nvim-treesitter updates rerun `:TSUpdate` automatically (the PackChanged
   hook in `pack.lua`).
3. Commit `nvim-pack-lock.json` and push.

**Pulling changes on another machine:**

1. `git pull`, then `:restart`. New plugins in the lockfile install at the
   pinned revision.
2. To move existing plugins to the lockfile revisions:
   `:lua vim.pack.update(nil, { target = "lockfile" })`, then `:write`.
3. If the lockfile dropped a plugin, remove it:
   `:PackDel <name>`. `git diff -- nvim-pack-lock.json` shows which ones.

**Mason packages aren't in the lockfile.** Rerun the `:MasonInstall` line
above when a server is added. Use `:Mason`, then `U`, to update installed
packages.

## Not synced (per machine)

- Plugins: `~/.local/share/nvim/site/pack/core/opt/`
- Mason packages: `~/.local/share/nvim/mason/`
- Undo history: `~/.local/state/nvim/undo/` (swap files are disabled)

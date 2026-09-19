-- ===============================================
-- Floating terminal
-- ===============================================
-- Toggling hides the window instead of closing it, so the shell, its job and
-- the scrollback survive until Neovim exits.

local state = { buf = nil, win = nil }

local function open()
  if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then
    state.buf = vim.api.nvim_create_buf(false, true)
  end

  local width = math.floor(vim.o.columns * 0.85)
  local height = math.floor(vim.o.lines * 0.8)
  state.win = vim.api.nvim_open_win(state.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " terminal ",
    title_pos = "center",
  })

  if vim.bo[state.buf].buftype ~= "terminal" then
    vim.fn.jobstart(vim.o.shell, { term = true }) -- uses 'shell' (pwsh on Windows)
  end
  vim.cmd.startinsert()
end

local function toggle()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_hide(state.win)
    state.win = nil
  else
    open()
  end
end

-- <C-\> shadows the builtin <C-\><C-n>, so <C-q> is the way back to normal mode.
vim.keymap.set({ "n", "t" }, "<C-\\>", toggle, { desc = "Toggle floating terminal" })
vim.keymap.set("t", "<C-q>", "<C-\\><C-n>", { desc = "Leave terminal mode" })

-- Unified sidebar contract helpers (one 3-state key per surface):
--   surface closed        → Space x opens + focuses it
--   surface open, outside → Space x jumps focus to it
--   surface open, inside  → Space x closes it
-- Used by keymaps.lua for leader shortcuts.
local M = {}

---@param ft string
---@return integer|nil
function M.win_by_ft(ft)
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(w)].filetype == ft then return w end
  end
end

--- Close a sidebar window by filetype. neo-tree buffers also get wiped —
--- closing the window alone leaves the buffer listed in the tabline, which
--- reads as "not closed". (neo-tree recreates it fresh on next open.)
---@param ft string
local function close_ft_window(ft)
  local win = M.win_by_ft(ft)
  if not win then return end
  local buf = vim.api.nvim_win_get_buf(win)
  pcall(vim.api.nvim_win_close, win, true)
  if ft == "neo-tree" and vim.api.nvim_buf_is_valid(buf) then pcall(vim.api.nvim_buf_delete, buf, { force = true }) end
end

---@param ft string
---@param open_cmd string
---@param focus_cmd string
---@return fun()
function M.toggle(ft, open_cmd, focus_cmd)
  return function()
    local win = M.win_by_ft(ft)
    if not win then
      vim.cmd(open_cmd)
      return
    end
    if vim.api.nvim_get_current_win() == win then
      close_ft_window(ft)
    else
      vim.cmd(focus_cmd)
    end
  end
end

--- Focus a normal editor window before opening a file or switching buffers.
function M.focus_editor()
  local function usable(win)
    return vim.api.nvim_win_get_config(win).relative == ""
      and vim.bo[vim.api.nvim_win_get_buf(win)].buftype == ""
      and not vim.wo[win].winfixbuf
  end
  local current = vim.api.nvim_get_current_win()
  if usable(current) then return end
  local alternate = vim.fn.win_getid(vim.fn.winnr "#")
  if alternate ~= 0 and usable(alternate) then
    vim.api.nvim_set_current_win(alternate)
    return
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if usable(win) then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
  vim.cmd "topleft vsplit"
  vim.wo.winfixbuf = false
  vim.cmd "enew"
end

--- Run editor-only navigation without replacing a sidebar's buffer.
---@param action fun()
---@return fun()
function M.in_editor(action)
  return function()
    M.focus_editor()
    action()
  end
end

--- Close every sidebar surface at once (Space q).
function M.close_all()
  for _, ft in ipairs { "neo-tree", "aerial" } do
    close_ft_window(ft)
  end
  local ok_panel, panel = pcall(require, "pi_nvim.panel")
  if ok_panel then pcall(panel.close) end
  -- Only close dap-ui if it was already loaded this session; requiring it
  -- fresh just to close it schedules errors in a pristine dap-ui.
  if package.loaded["dapui"] then pcall(require("dapui").close) end
end

return M

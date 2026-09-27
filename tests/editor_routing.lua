-- Run: nvim --headless -u NONE -l tests/editor_routing.lua
local sidebar = dofile(vim.fn.stdpath "config" .. "/lua/sidebar.lua")
vim.o.swapfile = false
vim.o.hidden = true
local editor = vim.api.nvim_get_current_win()
local original = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_lines(original, 0, -1, false, { "editor contents" })
local windows, buffers = {}, {}
for _, name in ipairs { "pi://chat", "pi://prompt" } do
  vim.cmd "botright vsplit"
  local win = vim.api.nvim_get_current_win()
  vim.wo[win].winfixbuf = false
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, name)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { name .. " draft" })
  vim.api.nvim_win_set_buf(win, buf)
  vim.wo[win].winfixbuf = true
  windows[#windows + 1], buffers[#buffers + 1] = win, buf
end
for _, win in ipairs(windows) do
  vim.api.nvim_set_current_win(win)
  sidebar.focus_editor()
  assert(vim.api.nvim_get_current_win() == editor, "must focus original editor")
end
local target = vim.api.nvim_create_buf(true, false)
vim.api.nvim_set_current_win(windows[2])
sidebar.in_editor(function() vim.api.nvim_set_current_buf(target) end)()
assert(vim.api.nvim_win_get_buf(editor) == target, "buffer switch must target editor")
vim.api.nvim_win_close(editor, true)
vim.api.nvim_set_current_win(windows[2])
sidebar.focus_editor()
assert(vim.bo.buftype == "" and not vim.wo.winfixbuf, "must create an editor when none remains")
for i, win in ipairs(windows) do
  assert(vim.api.nvim_win_get_buf(win) == buffers[i], "must retain sidebar buffer")
  assert(vim.api.nvim_buf_get_lines(buffers[i], 0, -1, false)[1]:find "draft", "must retain draft")
end
print "Editor routing PASS"
vim.cmd "qa!"

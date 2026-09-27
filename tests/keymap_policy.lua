-- Run: nvim --headless -u NONE -l tests/keymap_policy.lua
local policy = dofile(vim.fn.stdpath "config" .. "/lua/keymap_policy.lua")
vim.g.mapleader = " "
local function item(key, desc, file, buffer, rhs)
  return { file = file, item = { lhs = key, desc = desc, buffer = buffer or 0, rhs = rhs } }
end
for _, entry in ipairs {
  item(" a", "Toggle pi"),
  item(" b", "Breakpoint"),
  item("gd", "Definition", nil, 5),
  item("l", "Open tree node", nil, 4),
  item("<F2>", "Pi sessions", nil, 7),
  item("grr", "References"),
  item("]b", "Next buffer"),
  item("gcc", "Toggle comment"),
  item("<C-Space>", "Completion", vim.fn.stdpath "data" .. "/lazy/blink.cmp/lua/blink/cmp/keymap.lua"),
} do
  assert(policy.visible(entry), "must keep " .. entry.item.lhs)
end
for _, entry in ipairs {
  item("<C-W>r", "Rotate", nil, 0, "<Nop>"),
  item("<Plug>internal", "Plugin internals"),
  item("[<C-T>", "Preview tag alias"),
  item("mystery", nil),
} do
  assert(not policy.visible(entry), "must hide " .. entry.item.lhs)
end
assert(policy.description(item("Y", ":help Y-default")) == "Yank to end of line")
assert(policy.description(item("grr", "vim.lsp.buf.references()")) == "References")
policy.setup()
for _, key in ipairs(policy.disabled_windows) do
  for _, mode in ipairs { "n", "x" } do
    assert(vim.fn.maparg(key, mode) == "<Nop>", "must disable " .. key)
  end
end
-- Ordinary Vim editing remains native and usable.
vim.o.swapfile = false
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "one", "two" })
vim.cmd "normal! ggyyp"
assert(vim.api.nvim_buf_get_lines(0, 0, -1, false)[2] == "one")
print "Keymap policy PASS"
vim.cmd "qa!"

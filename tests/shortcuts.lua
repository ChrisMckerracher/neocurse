-- Run: nvim --headless -u NONE -l tests/shortcuts.lua
vim.g.mapleader = " "
vim.o.swapfile = false
require "keymaps"
-- Load the declarative debugger keys without starting its plugins or adapters.
local dap = dofile(vim.fn.stdpath "config" .. "/lua/plugins/dap.lua")[1]
for _, mapping in ipairs(dap.keys) do
  vim.keymap.set(mapping.mode or "n", mapping[1], mapping[2], { desc = mapping.desc })
end
local pi = dofile(vim.fn.stdpath "config" .. "/lua/plugins/pi.lua")[1]
assert(pi.opts.keymaps == false, "config must own the Pi key layout")
for _, mode in ipairs { "n", "x" } do
  local mappings = vim.api.nvim_get_keymap(mode)
  for _, a in ipairs(mappings) do
    if a.lhs:sub(1, 1) == " " then
      for _, b in ipairs(mappings) do
        assert(
          a.lhs == b.lhs or b.lhs:sub(1, #a.lhs) ~= a.lhs,
          "ambiguous " .. mode .. " shortcut: " .. a.lhs .. " / " .. b.lhs
        )
      end
    end
  end
end
for _, key in ipairs { " a", " e", " lf", " E", " pn", " pf", " pd", " pS" } do
  assert(vim.fn.maparg(key, "n") ~= "", key .. " missing")
end
for _, key in ipairs { " an", " af", " ad", " f", " ev" } do
  assert(vim.fn.maparg(key, "n") == "", key .. " must not remain")
end
assert(vim.fn.maparg(" pk", "x") ~= "")
require "autocmds"
vim.api.nvim_exec_autocmds("LspAttach", { buffer = 0, data = { client_id = -1 } })
assert(vim.fn.maparg("gr", "n") == "", "ambiguous reference alias must be removed")
assert(vim.fn.maparg("grr", "n") ~= "", "reference mapping must remain")
-- Closing a code buffer from a protected sidebar must use the editor window.
local editor = vim.api.nvim_get_current_win()
vim.cmd "vsplit"
local sidebar_win = vim.api.nvim_get_current_win()
local scratch = vim.api.nvim_create_buf(false, true)
vim.api.nvim_win_set_buf(sidebar_win, scratch)
vim.wo.winfixbuf = true
local closed_from
package.loaded["mini.bufremove"] = { delete = function() closed_from = vim.api.nvim_get_current_win() end }
vim.fn.maparg(" c", "n", false, true).callback()
assert(closed_from == editor, "close buffer must target editor")
assert(vim.api.nvim_win_get_buf(sidebar_win) == scratch, "sidebar must survive")
print "Shortcut collisions and routing PASS"
vim.cmd "qa!"

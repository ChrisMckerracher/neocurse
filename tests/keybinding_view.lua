-- Run: nvim --headless -u NONE -l tests/keybinding_view.lua
vim.g.mapleader = " "
local view = require "keybinding_view"
local function item(key, mode, buffer, desc)
  return {
    key = key,
    mode = mode or "n",
    item = { lhs = key, mode = mode or "n", buffer = buffer or 0, desc = desc or key },
  }
end
local function keys(items)
  local result = {}
  for _, entry in ipairs(items) do
    result[entry.mode .. ":" .. entry.key] = entry
  end
  return result
end
local items = {
  item " a",
  item " e",
  item " wh",
  item " pf",
  item(" pk", "x"),
  item " pn",
  item " b",
  item " E",
  item " lf",
  item "grr",
  item " fr",
  item("gi", "n", 4),
  item "gri",
  item(" lr", "n", 4),
  item "grn",
  item "<C-K>",
  item("<C-K>", "i", 4),
  item("<C-S>", "i"),
  item("gd", "n", 4),
  item("gd", "n", 0),
  item " lq",
}
local editor = keys(view.select(items, { scope = "editor", has_lsp = true }))
assert(editor["n: a"] and editor["n: pf"] and editor["x: pk"] and editor["n: b"])
assert(not editor["n: pn"], "Pi session controls should not clutter code context")
assert(editor["n:grr"] and not editor["n: fr"], "references must have one preferred entry")
assert(editor["n:gi"] and not editor["n:gri"])
assert(editor["n: lr"] and not editor["n:grn"])
assert(editor["i:<C-K>"] and not editor["i:<C-S>"])
assert(editor["n:gd"].item.buffer == 4, "local mapping must win")
local pane_items =
  { item " a", item " wh", item " pn", item " b", item " lf", item("<F2>", "n", 7), item("<C-C>", "i", 7) }
local pi = keys(view.select(pane_items, { scope = "pi", chat = false }))
assert(pi["n: pn"] and pi["n:<F2>"] and pi["i:<C-C>"])
assert(not pi["n: b"] and not pi["n: lf"])
local tree = keys(
  view.select({ item " wh", item " pn", item " b", item("l", "n", 9, "Open file"), item "grr" }, { scope = "tree" })
)
assert(tree["n:l"] and tree["n: wh"] and not tree["n: pn"] and not tree["n:grr"])
local no_lsp = keys(view.select({ item "grr", item " lf", item " ff" }, { scope = "editor", has_lsp = false }))
assert(not no_lsp["n:grr"] and no_lsp["n: lf"] and no_lsp["n: ff"])
print "Context keybindings PASS"
vim.cmd "qa!"

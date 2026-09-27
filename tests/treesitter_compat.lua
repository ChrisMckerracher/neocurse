-- Run: nvim --headless -u NONE -l tests/treesitter_compat.lua
vim.opt.rtp:prepend(vim.fn.stdpath "data" .. "/lazy/nvim-treesitter")
local query = vim.treesitter.query
local predicate, directive = query.add_predicate, query.add_directive
require("treesitter_compat").setup()
require "nvim-treesitter.query_predicates"
assert(query.add_predicate == predicate and query.add_directive == directive, "query APIs must be restored")
local buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "# Example", "", "```lua", "local value = 42", "```" })
local parser = vim.treesitter.get_parser(buf, "markdown")
local tree = parser:parse(true)[1]
assert(tree, "Markdown must parse")
local children = parser:children()
assert(children.lua, "Lua fenced block must retain language injection")
vim.treesitter.start(buf, "markdown")
parser:parse(true)
-- Exercise the real pinned directive rather than just the adapter shape.
local injection = vim.treesitter.query.get("markdown", "injections")
local count = 0
for _, _, metadata in injection:iter_matches(tree:root(), buf) do
  if metadata["injection.language"] == "lua" then count = count + 1 end
end
assert(count > 0, "Markdown language directive must see captured node")
vim.api.nvim_buf_delete(buf, { force = true })
print "Treesitter compatibility PASS"
vim.cmd "qa!"

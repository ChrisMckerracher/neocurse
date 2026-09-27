-- The pinned classic Treesitter plugin requests the pre-0.12 single-node API.
-- Adapt only its registrations; do not patch Neovim's query APIs permanently.
local M = {}

---@param handler function
---@return function
local function single_capture(handler)
  return function(match, ...)
    local legacy = {}
    for id, nodes in pairs(match) do
      legacy[id] = type(nodes) == "table" and nodes[#nodes] or nodes
    end
    return handler(legacy, ...)
  end
end

function M.setup()
  if vim.fn.has "nvim-0.12" == 0 then return end
  local module = "nvim-treesitter.query_predicates"
  assert(not package.loaded[module], "Treesitter compatibility must load before query predicates")
  package.preload[module] = function()
    local query = vim.treesitter.query
    local originals = { add_predicate = query.add_predicate, add_directive = query.add_directive }
    for name, register in pairs(originals) do
      query[name] = function(key, handler, opts)
        if type(opts) == "table" and opts.all == false then handler = single_capture(handler) end
        return register(key, handler, opts)
      end
    end
    local ok, result = xpcall(function()
      local path = vim.api.nvim_get_runtime_file("lua/nvim-treesitter/query_predicates.lua", false)[1]
      assert(path, "Missing installed Treesitter query predicates")
      return assert(loadfile(path))()
    end, debug.traceback)
    for name, register in pairs(originals) do
      query[name] = register
    end
    if not ok then error(result) end
    return result or true
  end
end

return M

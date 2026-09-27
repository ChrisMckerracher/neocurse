-- A snapshot of the originating window's effective, relevant shortcuts.
local policy = require "keymap_policy"
local M = {}
local labels = {
  editor = "Editor",
  pi = "Pi",
  tree = "File tree",
  debug = "Debugger",
  structure = "Structure",
  other = "This window",
}

---@param buf integer
---@return table
function M.context(buf)
  local ft, name = vim.bo[buf].filetype, vim.api.nvim_buf_get_name(buf)
  local scope = name:match "^pi://" and "pi"
    or ft == "neo-tree" and "tree"
    or (ft:match "^dap" or ft == "dap-repl") and "debug"
    or ft == "aerial" and "structure"
    or vim.bo[buf].buftype == "" and "editor"
    or "other"
  return { buf = buf, scope = scope, has_lsp = #vim.lsp.get_clients { bufnr = buf } > 0, chat = name == "pi://chat" }
end

-- Preferred LSP spelling first; native aliases remain usable but not duplicated.
local aliases = {
  { "grr", " fr" },
  { "gi", "gri" },
  { "gy", "grt" },
  { " lr", "grn" },
  { " la", "gra" },
  { " fs", "gO" },
  { "<C-K>", "<C-S>" },
  { " ld", "<C-W>d", "<C-W><C-D>" },
}
local groups = {}
for id, keys in ipairs(aliases) do
  for rank, key in ipairs(keys) do
    groups[key] = { id = id, rank = rank }
  end
end
local lsp_keys = {
  gd = true,
  gD = true,
  gi = true,
  gy = true,
  grr = true,
  gri = true,
  grt = true,
  grn = true,
  gra = true,
  grx = true,
  gO = true,
  K = true,
}
local common = {
  [" ?"] = true,
  [" a"] = true,
  [" e"] = true,
  [" v"] = true,
  [" d"] = true,
  [" q"] = true,
  [" ff"] = true,
  [" fw"] = true,
  [" fb"] = true,
  [" f?"] = true,
  ["<C-H>"] = true,
  ["<C-J>"] = true,
  ["<C-K>"] = true,
  ["<C-L>"] = true,
  ["<C-Left>"] = true,
  ["<C-Right>"] = true,
  ["<C-Up>"] = true,
  ["<C-Down>"] = true,
}
local debug_keys =
  { [" b"] = true, [" B"] = true, [" r"] = true, [" n"] = true, [" i"] = true, [" o"] = true, [" E"] = true }
local editor_pi = { [" pf"] = true, [" ps"] = true, [" pk"] = true, [" pd"] = true, [" pD"] = true }

local function relevant(item, ctx)
  if not policy.visible(item) then return false end
  local map, mode = item.item, item.mode
  if mode == "c" or mode == "t" then return false end
  if
    ctx.scope ~= "editor"
    and mode ~= "n"
    and not (mode == "i" and (ctx.scope == "debug" or ctx.scope == "pi" and not ctx.chat))
  then
    return false
  end
  if map.buffer and map.buffer > 0 then return true end
  local key = map.lhs
  if mode == "n" and (common[key] or key:match "^ w") then return true end
  if key:match "^ p" then
    return ctx.scope == "pi" and key ~= " pf" and key ~= " ps" and key ~= " pk"
      or ctx.scope == "editor" and editor_pi[key] == true
  end
  if debug_keys[key] then return ctx.scope == "editor" or ctx.scope == "debug" end
  if ctx.scope ~= "editor" then return false end
  if
    lsp_keys[key]
    or key:match "^ l[rah]$"
    or key == " fr"
    or key == " fs"
    or key == " fS"
    or mode == "i" and key == "<C-S>"
  then
    return ctx.has_lsp
  end
  return true
end

---@param items table[]
---@param ctx table
---@return table[]
function M.select(items, ctx)
  local effective = {}
  for _, item in ipairs(items) do
    local id = item.mode .. "\0" .. item.item.lhs
    if not effective[id] or (item.item.buffer or 0) > 0 then effective[id] = item end
  end
  local chosen, result = {}, {}
  for _, item in pairs(effective) do
    if relevant(item, ctx) then
      local group = groups[item.item.lhs]
      if group then
        local id = item.mode .. ":" .. group.id
        local old = chosen[id]
        if not old or group.rank < groups[old.item.lhs].rank then chosen[id] = item end
      else
        result[#result + 1] = item
      end
    end
  end
  for _, item in pairs(chosen) do
    result[#result + 1] = item
  end
  for _, item in ipairs(result) do
    item.text = table.concat({ item.key, item.mode, policy.description(item) }, " ")
  end
  table.sort(result, function(a, b)
    if a.item.lhs == b.item.lhs then return a.mode < b.mode end
    return a.item.lhs < b.item.lhs
  end)
  return result
end

function M.show()
  local ctx = M.context(vim.api.nvim_get_current_buf())
  local items = require("snacks.picker.source.vim").keymaps {
    modes = { "n", "x", "s", "o", "i" },
    global = true,
    ["local"] = true,
    plugs = false,
  }
  Snacks.picker {
    title = "Keybindings · " .. labels[ctx.scope],
    items = M.select(items, ctx),
    layout = { preset = "select", preview = false, layout = { border = "single" } },
    format = function(item)
      return {
        { string.format(" %-2s ", item.mode), "SnacksPickerSpecial" },
        { string.format("%-24s", Snacks.util.normkey(item.key)), "SnacksPickerLabel" },
        { policy.description(item), "SnacksPickerDesc" },
      }
    end,
    win = { input = { keys = { ["<Esc>"] = { "close", mode = { "n", "i" } } } } },
    confirm = function(picker) picker:close() end,
  }
end

return M

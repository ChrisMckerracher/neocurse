-- Keep the keybinding reference focused on this editor's supported workflows.
local M = {}

-- These native window operations are not part of the neocurse interface.
-- Navigation, file/buffer editing, splits and Pi divider sizing stay available.
M.disabled_windows = {
  "<C-w>r",
  "<C-w>R",
  "<C-w><C-r>", -- rotate
  "<C-w>x",
  "<C-w><C-x>", -- exchange
  "<C-w>H",
  "<C-w>J",
  "<C-w>K",
  "<C-w>L",
  "<C-w>T", -- rearrange/detach
  "<C-w>=",
  "<C-w>_",
  "<C-w><C-_>",
  "<C-w>|", -- equalize/maximize
}

-- Useful core mappings that have no config/plugin source file. Ordinary Vim
-- commands (motions, edits, :write, :quit, etc.) are otherwise left untouched.
local core_keys = {}
for _, key in ipairs {
  "j",
  "k",
  "Y",
  "&",
  "gc",
  "gcc",
  "gx",
  "[b",
  "]b",
  "[B",
  "]B",
  "[q",
  "]q",
  "[Q",
  "]Q",
  "[l",
  "]l",
  "[L",
  "]L",
  "[d",
  "]d",
  "[D",
  "]D",
  "[ ",
  "] ",
  "gO",
  "grt",
  "gri",
  "grr",
  "grx",
  "gra",
  "grn",
  "<Tab>",
  "<S-Tab>",
  "<C-S>",
  "<C-U>",
  "<C-W>",
  "<C-W>d",
  "<C-W><C-D>",
  "#",
  "*",
  "@",
  "Q",
} do
  core_keys[key] = true
end

local labels = {
  Y = "Yank to end of line",
  ["&"] = "Repeat last substitution",
  ["[b"] = "Previous buffer",
  ["]b"] = "Next buffer",
  ["[B"] = "First buffer",
  ["]B"] = "Last buffer",
  ["[q"] = "Previous quickfix item",
  ["]q"] = "Next quickfix item",
  ["[Q"] = "First quickfix item",
  ["]Q"] = "Last quickfix item",
  ["[l"] = "Previous location-list item",
  ["]l"] = "Next location-list item",
  ["[L"] = "First location-list item",
  ["]L"] = "Last location-list item",
  ["<C-W>"] = "Delete previous word",
  ["<C-U>"] = "Delete to start of line",
  ["#"] = "Search selection backward",
  ["*"] = "Search selection forward",
  ["@"] = "Run macro",
  Q = "Repeat last macro",
  gO = "Document symbols",
  grt = "Type definition",
  gri = "Implementation",
  grr = "References",
  grx = "Run code lens",
  gra = "Code action",
  grn = "Rename symbol",
}

---@param item table
---@return string
function M.description(item)
  local mapping = item.item
  local desc = mapping.desc or ""
  if desc:match "^:" or desc:match "^vim%.lsp" then return labels[mapping.lhs] or desc end
  return desc
end

---@param item table Snacks keymap finder item
---@return boolean
function M.visible(item)
  local mapping = item.item
  if not mapping or not mapping.desc or mapping.desc == "" then return false end
  if mapping.rhs and mapping.rhs:lower() == "<nop>" then return false end
  if mapping.lhs:match "^<Plug>" then return false end
  -- Buffer-local mappings belong to the active plugin/LSP surface.
  if mapping.buffer and mapping.buffer > 0 then return true end
  local leader = vim.g.mapleader or "\\"
  if mapping.lhs:sub(1, #leader) == leader then return true end
  if core_keys[mapping.lhs] then return true end
  if item.file then
    local path = vim.fs.normalize(item.file)
    for _, root in ipairs { vim.fn.stdpath "config", vim.fn.stdpath "data" .. "/lazy" } do
      root = vim.fs.normalize(root) .. "/"
      if path:sub(1, #root) == root then return true end
    end
  end
  -- Explicit string mappings without callback locations.
  return vim.tbl_contains({ "<Esc>", "<C-H>", "<C-J>", "<C-K>", "<C-L>" }, mapping.lhs)
end

--- Disable only unwanted window manipulation shortcuts; no-op maps are hidden.
function M.setup()
  for _, key in ipairs(M.disabled_windows) do
    vim.keymap.set({ "n", "x" }, key, "<Nop>", { silent = true })
  end
end

return M

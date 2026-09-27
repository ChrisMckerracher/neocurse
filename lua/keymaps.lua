-- All keybindings in one place. LSP buffer-local maps live in autocmds.lua
-- (LspAttach). Cheat sheet: KEYBINDINGS.md (kept in sync).
local map = vim.keymap.set
local sidebar = require "sidebar"

-- Move by display line when lines wrap (small screens), by line with a count
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Window navigation / resize. Arrows move the divider visually: when the
-- pi panel is open, <C-Left> grows it and <C-Right> shrinks it (editor
-- and panel are siblings); otherwise the flip logic keeps arrows honest.
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Space w is a discoverable companion to native Ctrl-w navigation.
for _, direction in ipairs { "h", "j", "k", "l", "w" } do
  map(
    "n",
    "<leader>w" .. direction,
    "<C-w>" .. direction,
    { desc = "Window " .. ({ h = "left", j = "down", k = "up", l = "right", w = "next" })[direction] }
  )
end
map("n", "<leader>we", sidebar.focus_editor, { desc = "Focus editor" })
map("n", "<leader>wt", "<cmd>Neotree focus<CR>", { desc = "Focus file tree" })
map("n", "<leader>wp", function() require("pi_nvim.panel").open() end, { desc = "Focus pi prompt" })

local function resize_vertical(dir)
  if vim.fn.winnr "h" == vim.fn.winnr() and vim.fn.winnr "l" == vim.fn.winnr() then return end -- no vertical split
  local ok, panel = pcall(require, "pi_nvim.panel")
  if ok and panel.is_open() then
    panel.resize(-dir * 4) -- <C-Left> (dir=-1) grows panel, <C-Right> shrinks
    return
  end
  local amount = dir * 4
  if vim.fn.winnr "l" == vim.fn.winnr() then amount = -amount end -- rightmost: flip
  -- pcall: shrinking an already-small window throws E36 (not enough room)
  pcall(vim.cmd, ("vertical resize %s%d"):format(amount > 0 and "+" or "", amount))
end
local function resize_horizontal(dir)
  local ok, panel = pcall(require, "pi_nvim.panel")
  if ok and panel.is_open() then
    panel.resize_height(dir) -- <C-Up> grows input, <C-Down> shrinks toward its floor
    return
  end
  if vim.fn.winnr "j" == vim.fn.winnr() and vim.fn.winnr "k" == vim.fn.winnr() then return end -- no horizontal split
  local amount = dir * 2
  if vim.fn.winnr "j" == vim.fn.winnr() then amount = -amount end -- bottommost: flip
  pcall(vim.cmd, ("resize %s%d"):format(amount > 0 and "+" or "", amount))
end
map("n", "<C-Left>", function() resize_vertical(-1) end, { desc = "Divider left (pi: grow panel)" })
map("n", "<C-Right>", function() resize_vertical(1) end, { desc = "Divider right (pi: shrink panel)" })
map("n", "<C-Up>", function() resize_horizontal(1) end, { desc = "Divider up" })
map("n", "<C-Down>", function() resize_horizontal(-1) end, { desc = "Divider down" })

-- Buffers ("tabs")
map("n", "<Tab>", sidebar.in_editor(function() vim.cmd "bnext" end), { desc = "Next buffer" })
map("n", "<S-Tab>", sidebar.in_editor(function() vim.cmd "bprevious" end), { desc = "Previous buffer" })
map("n", "<leader>c", function() require("mini.bufremove").delete(0, false) end, { desc = "Close buffer" })
for i = 1, 9 do
  map("n", "<leader>" .. i, function()
    sidebar.focus_editor()
    local bufs = vim.fn.getbufinfo { buflisted = 1 }
    if bufs[i] then vim.cmd.buffer(bufs[i].bufnr) end
  end, { desc = "Go to buffer " .. i })
end

-- Files
-- Unified sidebar contract lives in lua/sidebar.lua (one 3-state key per
-- surface): closed → open+focus · outside → focus · inside → close.
map("n", "<leader>e", sidebar.toggle("neo-tree", "Neotree focus", "Neotree focus"), { desc = "File tree" })

-- Close every sidebar at once (tree, structure, pi panel, debug UI)
map("n", "<leader>q", sidebar.close_all, { desc = "Close all sidebars" })

-- Run current file
map("n", "<leader>R", function()
  local ft = vim.bo.filetype
  local file = vim.fn.expand "%:p"
  if ft == "python" then
    vim.cmd("!python " .. vim.fn.shellescape(file))
  elseif ft == "go" then
    vim.cmd "!go run ."
  elseif ft == "typescript" or ft == "javascript" then
    vim.cmd("!node " .. vim.fn.shellescape(file))
  else
    vim.notify("No run command for filetype: " .. ft, vim.log.levels.WARN)
  end
end, { desc = "Run current file" })

-- Format (conform; LSP fallback)
map(
  { "n", "v" },
  "<leader>f",
  function() require("conform").format { async = true, lsp_format = "fallback" } end,
  { desc = "Format" }
)

-- Diagnostics
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- Search (snacks.picker)
map("n", "<leader>ff", sidebar.in_editor(function() Snacks.picker.files() end), { desc = "Find files" })
map("n", "<leader>fw", sidebar.in_editor(function() Snacks.picker.grep() end), { desc = "Grep (live)" })
map("n", "<leader>fb", sidebar.in_editor(function() Snacks.picker.buffers() end), { desc = "Find buffer" })
map("n", "<leader>fs", sidebar.in_editor(function() Snacks.picker.lsp_symbols() end), { desc = "Document symbols" })
map(
  "n",
  "<leader>fS",
  sidebar.in_editor(function() Snacks.picker.lsp_workspace_symbols() end),
  { desc = "Workspace symbols" }
)
map("n", "<leader>fr", sidebar.in_editor(function() Snacks.picker.lsp_references() end), { desc = "References" })
map("n", "<leader>fd", sidebar.in_editor(function() Snacks.picker.diagnostics() end), { desc = "Diagnostics" })
map("n", "<leader>f?", sidebar.in_editor(function() Snacks.picker.resume() end), { desc = "Resume picker" })

-- Structure view (same 3-state sidebar contract)
map("n", "<leader>v", sidebar.toggle("aerial", "AerialOpen", "AerialFocus"), { desc = "Structure view" })

-- Search live shortcuts, including mappings attached to the current buffer.
local function keybindings()
  Snacks.picker.keymaps {
    title = "Keybindings · Space is leader",
    layout = { preset = "select", preview = false, layout = { border = "single" } },
    format = function(item)
      return {
        { string.format(" %-2s ", item.mode), "SnacksPickerSpecial" },
        { string.format("%-24s", Snacks.util.normkey(item.key)), "SnacksPickerLabel" },
        { item.item.desc or item.item.rhs or "Custom mapping", "SnacksPickerDesc" },
      }
    end,
    -- This is a reference picker: mappings span several modes, so executing
    -- a selected insert/visual mapping from normal mode would be misleading.
    confirm = function(picker) picker:close() end,
  }
end
map("n", "<leader>?", keybindings, { desc = "Search keybindings" })
vim.api.nvim_create_user_command("Keymaps", keybindings, { desc = "Search keybindings" })

-- Ctrl+click → go to definition (PyCharm-style)
map("n", "<C-LeftMouse>", function()
  local pos = vim.fn.getmousepos()
  if pos.winid ~= 0 then
    vim.api.nvim_set_current_win(pos.winid)
    vim.api.nvim_win_set_cursor(pos.winid, { pos.line, math.max(0, pos.column - 1) })
  end
  vim.lsp.buf.definition()
end, { desc = "Go to definition" })

-- Right-click menu (options.mousemodel = "popup" shows this without moving
-- the cursor). Native :menu — no plugin.
vim.cmd [[
  aunmenu PopUp
  nmenu PopUp.Rename\ Symbol <cmd>lua vim.lsp.buf.rename()<CR>
  nmenu PopUp.Refactor… <cmd>lua vim.lsp.buf.code_action({ context = { only = { "refactor" } } })<CR>
  nmenu PopUp.Code\ Action <cmd>lua vim.lsp.buf.code_action()<CR>
  nmenu PopUp.Go\ to\ Definition <cmd>lua vim.lsp.buf.definition()<CR>
  nmenu PopUp.Find\ References <cmd>lua vim.lsp.buf.references()<CR>
  nmenu PopUp.Format <cmd>lua require("conform").format({ async = true, lsp_format = "fallback" })<CR>
  nmenu PopUp.-sep- :
  vmenu PopUp.Ask\ pi <cmd>lua require("pi_nvim").send_selection()<CR>
  nmenu PopUp.Ask\ pi\ (file) <cmd>lua require("pi_nvim").send_file()<CR>
]]

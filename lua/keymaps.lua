-- All keybindings in one place. LSP buffer-local maps live in autocmds.lua
-- (LspAttach). Cheat sheet: KEYBINDINGS.md (kept in sync).
local map = vim.keymap.set

-- Move by display line when lines wrap (small screens), by line with a count
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Window navigation / resize
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Window taller" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Window shorter" })
map("n", "<C-Left>", "<cmd>vertical resize -4<CR>", { desc = "Window narrower" })
map("n", "<C-Right>", "<cmd>vertical resize +4<CR>", { desc = "Window wider" })

-- Buffers ("tabs")
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>c", function() require("mini.bufremove").delete(0, false) end, { desc = "Close buffer" })
for i = 1, 9 do
  map("n", "<leader>" .. i, function()
    local bufs = vim.fn.getbufinfo { buflisted = 1 }
    if bufs[i] then vim.cmd.buffer(bufs[i].bufnr) end
  end, { desc = "Go to buffer " .. i })
end

-- Files
map("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "File explorer" })

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
map({ "n", "v" }, "<leader>f", function() require("conform").format { async = true, lsp_format = "fallback" } end, { desc = "Format" })

-- Diagnostics
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- Search (snacks.picker)
map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find files" })
map("n", "<leader>fw", function() Snacks.picker.grep() end, { desc = "Grep (live)" })
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Find buffer" })
map("n", "<leader>fs", function() Snacks.picker.lsp_symbols() end, { desc = "Document symbols" })
map("n", "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Workspace symbols" })
map("n", "<leader>fr", function() Snacks.picker.lsp_references() end, { desc = "References" })
map("n", "<leader>fd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
map("n", "<leader>f?", function() Snacks.picker.resume() end, { desc = "Resume picker" })

-- Structure view
map("n", "<leader>v", "<cmd>AerialToggle left<CR>", { desc = "Structure view" })

-- Cheatsheet
map("n", "<leader>?", "<cmd>edit " .. vim.fn.stdpath "config" .. "/KEYBINDINGS.md<CR>", { desc = "Keybindings cheatsheet" })

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

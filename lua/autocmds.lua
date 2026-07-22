-- Autocommands: autosave/autoreload (agent-friendly), yank flash,
-- wide-screen-only neo-tree auto-open, and LSP buffer wiring on attach.
local group = vim.api.nvim_create_augroup("UserConfig", { clear = true })
local function au(event, opts)
  opts.group = group
  vim.api.nvim_create_autocmd(event, opts)
end

-- Sharp float borders everywhere, consistent with the panel style
vim.diagnostic.config { float = { border = "single" } }

-- Save on idle / focus loss
au({ "CursorHold", "FocusLost" }, {
  callback = function()
    if vim.bo.modified and vim.bo.buftype == "" and vim.bo.buflisted then vim.cmd "silent! write" end
  end,
})

-- Reload files changed outside the editor
au({ "CursorHold", "FocusGained", "BufEnter" }, {
  callback = function() vim.cmd "checktime" end,
})
au("VimEnter", {
  callback = function()
    vim.fn.timer_start(3000, function() vim.cmd "silent! checktime" end, { ["repeat"] = -1 })
  end,
})

-- Flash yanked text
au("TextYankPost", {
  callback = function() vim.hl.on_yank { timeout = 150 } end,
})

-- neo-tree auto-opens only when there's room for it (external monitor).
-- On the Pocket Reform's screen the space belongs to code.
au("VimEnter", {
  nested = true,
  callback = function()
    if vim.o.columns >= 120 and (vim.fn.isdirectory(vim.fn.argv(0)) == 1 or vim.fn.bufname() == "") then
      vim.cmd "Neotree show"
    end
  end,
})

-- LSP: buffer-local keybinds + inlay hints on attach
au("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local function map(lhs, fn, desc, mode) vim.keymap.set(mode or "n", lhs, fn, { buffer = bufnr, desc = desc }) end

    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
    map("gi", vim.lsp.buf.implementation, "Go to implementation")
    map("gy", vim.lsp.buf.type_definition, "Go to type definition")
    map("gr", vim.lsp.buf.references, "References")
    map("K", function() vim.lsp.buf.hover { border = "single" } end, "Hover documentation")
    map("<leader>lr", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>la", vim.lsp.buf.code_action, "Code action")
    map("<C-k>", vim.lsp.buf.signature_help, "Signature help", "i")

    if client and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
    map(
      "<leader>lh",
      function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }, { bufnr = bufnr }) end,
      "Toggle inlay hints"
    )
  end,
})

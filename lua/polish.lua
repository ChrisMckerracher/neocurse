-- Runs last in setup. Force settings that AstroNvim tries to override.
vim.opt.relativenumber = false
vim.opt.number = true

-- Force on every buffer open too
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.wo.relativenumber = false
    vim.wo.number = true
  end,
})

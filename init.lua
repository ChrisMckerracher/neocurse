-- From-scratch Neovim config — no distribution, every line owned here.
-- Languages: Go, Python, TypeScript. Design: ide-plan.md. Cheatsheet: KEYBINDINGS.md.

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local result =
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Error cloning lazy.nvim:\n" .. result, "ErrorMsg" } }, true, {})
    vim.fn.getchar()
    vim.cmd.quit()
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = ","

require "options"
require "keymaps"
require "autocmds"

require("lazy").setup("plugins", {
  install = { colorscheme = { "tokyonight-night", "habamax" } },
  ui = { border = "rounded" },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "netrwPlugin", "tarPlugin", "tohtml", "zipPlugin", "matchit", "rplugin" },
    },
  },
})

require "lsp"

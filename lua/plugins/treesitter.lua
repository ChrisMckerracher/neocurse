-- Treesitter parsers for syntax highlighting and code understanding
---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "go",
      "python",
      "typescript",
      "tsx",
      "lua",
      "vim",
      "markdown",
      "markdown_inline",
    },
  },
}

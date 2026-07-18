-- LSP configuration: format on save, inlay hints, language servers
---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    features = {
      codelens = true,
      inlay_hints = true, -- PyCharm-style type/param hints
      semantic_tokens = true,
    },
    formatting = {
      format_on_save = {
        enabled = true,
        allow_filetypes = {
          "go",
          "python",
          "typescript",
          "typescriptreact",
          "javascript",
          "javascriptreact",
        },
      },
      timeout_ms = 1000,
    },
    servers = {
      "pyright",
      "gopls",
      "ts_ls",
    },
  },
}

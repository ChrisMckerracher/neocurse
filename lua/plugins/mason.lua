-- Mason tool installer: auto-install language servers, formatters, debuggers
---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- Go (requires `go` installed on system — install Go first)
        -- "gopls", "goimports", "delve",
        -- Python
        "pyright",
        "ruff",
        "debugpy",
        -- TypeScript
        "typescript-language-server",
        "js-debug-adapter",
        "prettier",
        -- Lua
        "lua-language-server",
        "stylua",
      },
    },
  },
}

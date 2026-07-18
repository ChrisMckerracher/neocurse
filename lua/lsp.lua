-- LSP: native Neovim 0.11 API (vim.lsp.config / vim.lsp.enable).
-- ONE strong server per language — the old setup attached up to 7 clients
-- per buffer (distro double-registration + pack-installed duplicates).
-- Server binaries come from mason (plugins/tools.lua); default configs from
-- nvim-lspconfig (data only).

-- Go
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      hints = { parameterNames = true, constantValues = true },
      analyses = { unusedparams = true, unusedwrite = true },
    },
  },
})

-- Python: pyright (Microsoft) for intelligence; ruff for lint/format.
-- Workspace diagnosticMode = real cross-file indexing for search.
vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        autoImportCompletions = true,
        diagnosticMode = "workspace",
        typeCheckingMode = "standard",
        useLibraryCodeForTypes = true,
      },
    },
  },
})

-- TypeScript/JavaScript: vtsls (VS Code's own server, community standard).
local ts_inlay = {
  parameterNames = { enabled = "literals" },
  parameterTypes = { enabled = false },
  variableTypes = { enabled = false },
  propertyDeclarationTypes = { enabled = false },
  functionLikeReturnTypes = { enabled = true },
  enumMemberValues = { enabled = false },
}
vim.lsp.config("vtsls", {
  settings = {
    typescript = { inlayHints = ts_inlay },
    javascript = { inlayHints = ts_inlay },
  },
})

-- Lua (this config + pi.nvim development)
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim", "Snacks" } },
      workspace = { checkThirdParty = false },
      format = { enable = false }, -- stylua via conform
    },
  },
})

vim.lsp.enable { "gopls", "pyright", "vtsls", "lua_ls", "ruff" }

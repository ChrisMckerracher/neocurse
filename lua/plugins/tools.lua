-- Tools: mason (binaries), file explorer, picker.
-- Declarative mason installs via ~20 lines we own (no tool-installer dep).
local MASON_TOOLS = {
  -- Python
  "pyright",
  "ruff",
  "debugpy",
  -- Go
  "gopls",
  "goimports",
  "delve",
  -- TypeScript
  "vtsls",
  "js-debug-adapter",
  "prettier",
  -- Lua
  "lua-language-server",
  "stylua",
}

return {
  { "neovim/nvim-lspconfig" }, -- default server configs (data) for vim.lsp.config
  {
    "mason-org/mason.nvim",
    opts = { ui = { border = "rounded" } },
    config = function(_, opts)
      require("mason").setup(opts)
      local registry = require "mason-registry"
      registry.refresh(function()
        for _, name in ipairs(MASON_TOOLS) do
          local ok, pkg = pcall(registry.get_package, name)
          if ok and pkg and not pkg:is_installed() then pkg:install() end
        end
      end)
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "nvim-tree/nvim-web-devicons" },
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      window = {
        -- Fraction of screen with clamps: Pocket Reform → 1440p both work.
        width = math.max(20, math.min(34, math.floor(vim.o.columns * 0.18))),
        mappings = { ["l"] = "open", ["h"] = "close_node", ["<space>"] = "none" },
      },
      filesystem = {
        use_libuv_file_watcher = true, -- agent-created files appear live
        follow_current_file = { enabled = true },
        filtered_items = { visible = true, hide_dotfiles = false },
      },
      default_component_configs = { indent = { padding = 0 } },
    },
  },

  {
    -- Search/indexing: picker ONLY — every other snacks module stays off.
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      picker = { enabled = true },
    },
  },
}

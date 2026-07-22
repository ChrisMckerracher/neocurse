-- Editor: syntax, completion, formatting, small comforts.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", -- classic configs API; the `main` rewrite removed it
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "go",
        "gomod",
        "python",
        "typescript",
        "tsx",
        "javascript",
        "lua",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
        "json",
      },
      highlight = { enable = true },
    },
    config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
  },

  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
      },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200, window = { border = "single" } },
        menu = { border = "single", draw = { columns = { { "label", "label_description", gap = 1 }, { "kind" } } } },
      },
      signature = { enabled = true, window = { border = "single" } },
      sources = { default = { "lsp", "path", "buffer" } },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
      notify_on_error = true,
      formatters_by_ft = {
        go = { "goimports" },
        python = { "ruff_format" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
      },
    },
  },

  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

  {
    "RRethy/vim-illuminate",
    opts = { delay = 200, large_file_cutoff = 2000 },
    config = function(_, opts) require("illuminate").configure(opts) end,
  },

  { "echasnovski/mini.bufremove", opts = {} },
}

-- UI: theme, statusline+tabline (one plugin), icons, structure view.
return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = { style = "night", styles = { sidebars = "dark", floats = "dark" } },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme "tokyonight-night"
    end,
  },

  { "nvim-tree/nvim-web-devicons", opts = {} },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "tokyonight",
        globalstatus = true,
        component_separators = "",
        section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = { "neo-tree", "aerial" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { { "filename", path = 1 } },
        lualine_c = { "diagnostics" },
        lualine_x = { { "lsp_status", ignore_lsp = { "pylsp", "null-ls" } }, "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      tabline = {
        lualine_a = { { "buffers", mode = 2, max_length = vim.o.columns * 0.7 } },
      },
    },
  },

  {
    -- Structure view: classes/functions/members of the current file (PyCharm's
    -- Structure tool window). <leader>v toggles (keymaps.lua).
    "stevearc/aerial.nvim",
    opts = {
      backends = { "lsp", "treesitter" },
      attach_mode = "global",
      layout = { min_width = 16, max_width = 30, default_direction = "left" },
      filter_kind = { "Class", "Interface", "Struct", "Enum", "Function", "Method", "Constant", "Constructor" },
      show_guides = true,
    },
  },
}

-- neo-tree: file explorer with auto-refresh for external changes
---@type LazySpec
return {
  "neo-tree.nvim",
  opts = {
    filesystem = {
      -- Auto-scan new files created outside nvim (e.g. by pi)
      use_libuv_file_watcher = true,
    },
  },
  config = function(_, opts)
    -- Let AstroNvim's neo-tree setup run first
    require("neo-tree").setup(opts)

    -- Auto-open neo-tree on startup
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        -- Only open if we have a valid directory or buffer
        if vim.fn.isdirectory(vim.fn.argv(0)) == 1 or vim.fn.bufname() == "" then
          vim.cmd("Neotree show")
        end
      end,
      nested = true,
    })
  end,
}

-- pi.nvim: Cursor-style agent integration — pi embedded via its SDK.
-- Repo: https://github.com/ChrisMckerracher/pi.nvim
---@type LazySpec
return {
  {
    "ChrisMckerracher/pi.nvim",
    main = "pi_nvim",
    lazy = false, -- small Lua surface; host process spawns lazily on first use
    build = "npm ci --prefix host && npm run build --prefix host",
    opts = { keymaps = false }, -- config owns the delay-free Space a / Space p layout
  },
}

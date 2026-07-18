-- pi.nvim: Cursor-style agent integration — pi embedded via its SDK.
-- Repo: ~/Code/pi.nvim (design: docs/architecture/design/001-*.md there)
---@type LazySpec
return {
  {
    "pi.nvim",
    dir = "~/Code/pi.nvim",
    main = "pi_nvim",
    lazy = false, -- small Lua surface; host process spawns lazily on first use
    build = "make build",
    opts = {},
  },
}

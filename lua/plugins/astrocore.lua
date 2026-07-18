-- Core config: options, keybindings, autocommands
---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    options = {
      opt = {
        relativenumber = false,
        number = true,
        signcolumn = "yes",
        wrap = true,
        linebreak = true,
        breakindent = true,

        autowrite = true, -- auto-save on buffer switch, make, etc.
        autoread = true, -- auto-reload files changed outside editor
      },
    },
    mappings = {
      n = {
        -- Buffer navigation (visual "tabs")
        ["<Tab>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["<S-Tab>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        ["<leader>c"] = {
          function() require("mini.bufremove").delete(0, false) end,
          desc = "Close buffer",
        },

        -- Debugging
        ["<leader>b"] = { function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
        ["<leader>r"] = { function() require("dap").continue() end, desc = "Start/continue debugging" },
        ["<leader>n"] = { function() require("dap").step_over() end, desc = "Step over" },
        ["<leader>i"] = { function() require("dap").step_into() end, desc = "Step into" },
        ["<leader>o"] = { function() require("dap").step_out() end, desc = "Step out" },
        ["<leader>d"] = { function() require("dapui").toggle() end, desc = "Toggle debug UI" },

        -- Run file (no debugger)
        ["<leader>R"] = { function()
          local filetype = vim.bo.filetype
          local filepath = vim.fn.expand "%:p"
          if filetype == "python" then
            vim.cmd(string.format("!python %s", filepath))
          elseif filetype == "go" then
            vim.cmd "!go run ."
          elseif filetype == "typescript" or filetype == "javascript" then
            vim.cmd(string.format("!node %s", filepath))
          else
            vim.notify("No run command for filetype: " .. filetype, vim.log.levels.WARN)
          end
        end, desc = "Run current file" },

        -- Formatting
        ["<leader>f"] = { function() vim.lsp.buf.format() end, desc = "Format current file" },

        -- Keybindings cheatsheet
        ["<leader>?"] = {
          function() vim.cmd("edit " .. vim.fn.stdpath "config" .. "/KEYBINDINGS.md") end,
          desc = "Open keybindings cheatsheet",
        },
      },
    },
    autocmds = {
      auto_save = {
        {
          event = { "CursorHold", "FocusLost" },
          callback = function()
            if vim.bo.modified and vim.bo.buflisted then vim.cmd "silent! write" end
          end,
        },
      },
      fix_inlay_hints = {
        {
          event = { "TextChanged", "TextChangedI" },
          callback = function()
            pcall(function() vim.lsp.inlay_hint.enable(true, { bufnr = 0 }) end)
          end,
        },
      },
      auto_refresh = {
        {
          event = "CursorHold",
          callback = function()
            vim.cmd "checktime"
          end,
        },
      },
      auto_refresh_timer = {
        {
          event = "UIEnter",
          callback = function()
            vim.fn.timer_start(3000, function()
              vim.cmd "silent! checktime"
            end, { ["repeat"] = -1 })
          end,
        },
      },
    },
  },
}

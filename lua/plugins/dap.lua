-- Debugging: DAP + UI + inline values. Adapters point at mason binaries
-- explicitly (the old config used system `python -m debugpy.adapter`, which
-- only works when system python happens to have debugpy installed).
local mason_bin = vim.fn.stdpath "data" .. "/mason/bin/"

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        opts = {
          icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
          layouts = {
            {
              elements = {
                { id = "scopes", size = 0.4 },
                { id = "stacks", size = 0.3 },
                { id = "breakpoints", size = 0.3 },
              },
              size = 30, -- small-screen friendly
              position = "left",
            },
            {
              elements = { { id = "repl", size = 1 } },
              size = 8,
              position = "bottom",
            },
          },
        },
      },
      { "theHamsta/nvim-dap-virtual-text", opts = {} }, -- inline variable values
    },
    keys = {
      { "<leader>b", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      {
        "<leader>B",
        function() require("dap").set_breakpoint(vim.fn.input "Condition: ") end,
        desc = "Conditional breakpoint",
      },
      { "<leader>r", function() require("dap").continue() end, desc = "Start/continue debugging" },
      { "<leader>n", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>i", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>o", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>d", function() require("dapui").toggle() end, desc = "Toggle debug UI" },
      { "<leader>ev", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Eval under cursor" },
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- Python
      dap.adapters.python = {
        type = "executable",
        command = mason_bin .. "debugpy-adapter",
      }
      local function python_path()
        local venv = os.getenv "VIRTUAL_ENV"
        if venv then return venv .. "/bin/python" end
        return "python"
      end
      dap.configurations.python = {
        { type = "python", request = "launch", name = "Launch file", program = "${file}", pythonPath = python_path },
        {
          type = "python",
          request = "launch",
          name = "FastAPI server",
          module = "uvicorn",
          args = { "${file}:app", "--reload" },
          pythonPath = python_path,
        },
      }

      -- Go
      dap.adapters.delve = {
        type = "server",
        port = "${port}",
        executable = { command = mason_bin .. "dlv", args = { "dap", "-l", "127.0.0.1:${port}" } },
      }
      dap.configurations.go = {
        { type = "delve", name = "Debug current file", request = "launch", program = "${file}" },
        { type = "delve", name = "Debug package", request = "launch", program = "${workspaceFolder}" },
        { type = "delve", name = "Debug test", request = "launch", mode = "test", program = "${file}" },
      }

      -- TypeScript / JavaScript
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = { command = mason_bin .. "js-debug-adapter", args = { "${port}" } },
      }
      dap.configurations.typescript = {
        { type = "pwa-node", request = "launch", name = "Launch file", program = "${file}", cwd = "${workspaceFolder}" },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch via ts-node",
          runtimeExecutable = "ts-node",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
      }
      dap.configurations.javascript = dap.configurations.typescript
    end,
  },
}

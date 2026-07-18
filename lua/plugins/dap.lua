-- DAP configuration: debug adapters and launch configs for Go, Python, TypeScript
---@type LazySpec
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" },
      opts = {
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "variables", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
      },
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      -- Auto-open/close dap-ui
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- Python
      dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
      }
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            local venv = os.getenv "VIRTUAL_ENV"
            if venv then return venv .. "/bin/python" end
            return "python"
          end,
        },
        {
          type = "python",
          request = "launch",
          name = "FastAPI server",
          module = "uvicorn",
          args = { "${file}:app", "--reload" },
          pythonPath = function()
            local venv = os.getenv "VIRTUAL_ENV"
            if venv then return venv .. "/bin/python" end
            return "python"
          end,
        },
      }

      -- Go
      dap.adapters.delve = {
        type = "server",
        port = "${port}",
        executable = {
          command = "dlv",
          args = { "dap", "-l", "127.0.0.1:${port}" },
        },
      }
      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug current file",
          request = "launch",
          program = "${file}",
        },
        {
          type = "delve",
          name = "Debug package",
          request = "launch",
          program = "${workspaceFolder}",
        },
        {
          type = "delve",
          name = "Debug test",
          request = "launch",
          mode = "test",
          program = "${file}",
        },
      }

      -- TypeScript / JavaScript
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "js-debug-adapter",
          args = { "${port}" },
        },
      }
      dap.configurations.typescript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
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

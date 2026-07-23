return {
  "mfussenegger/nvim-dap",
  keys = {
    { "<leader>bb", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
    { "<leader>bs", function() require("dap").step_into() end, desc = "Step into" },
    { "<leader>bn", function() require("dap").step_over() end, desc = "Step over" },
    { "<leader>br", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
    { "<leader>bj", function() require("dap").goto_() end, desc = "Jump to cursor" },
    { "<leader>bc", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>bo", function() require("dap").step_out() end, desc = "Step out" },
    {
      "<leader>dc",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Conditional breakpoint",
    },
    { "<Tab>dd", function() require("dap").continue() end, desc = "Select and start debugging" },
    { "<Tab>td", function() require("dap").repl.toggle() end, desc = "Debug REPL" },
  },
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" },
      opts = {
        layouts = {
          {
            elements = { "scopes", "breakpoints", "stacks", "watches" },
            size = 30,
            position = "left",
          },
          {
            elements = { "repl", "console" },
            size = 10,
            position = "bottom",
          },
        },
      },
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = { "mason-org/mason.nvim" },
      opts = {
        ensure_installed = { "codelldb" },
        automatic_installation = true,
        handlers = {},
      },
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dap.listeners.after.event_initialized["dapui"] = dapui.open
    dap.listeners.before.event_terminated["dapui"] = function()
      dapui.close()
      dap.repl.close()
    end
    dap.listeners.before.event_exited["dapui"] = function()
      dapui.close()
      dap.repl.close()
    end

    local codelldb = vim.fn.stdpath("data") .. "/mason/bin/codelldb"
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = { command = codelldb, args = { "--port", "${port}" } },
    }

    local launch = {
      name = "Launch executable",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    }
    dap.configurations.c = { launch }
    dap.configurations.cpp = dap.configurations.c
    dap.configurations.rust = dap.configurations.c

    require("dap.ext.vscode").load_launchjs(nil, {
      codelldb = { "c", "cpp", "rust" },
      cppdbg = { "c", "cpp", "rust" },
    })
  end,
}

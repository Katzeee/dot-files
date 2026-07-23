local icons = require("core.icons")

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<leader>tt", desc = "Floating terminal" },
      { "<leader>tl", desc = "Lazygit" },
    },
    config = function()
      require("toggleterm").setup({
        shade_terminals = true,
        shading_factor = 1,
        float_opts = { border = icons.nerd and "double" or "none" },
      })

      local Terminal = require("toggleterm.terminal").Terminal
      local float = Terminal:new({ direction = "float", hidden = true })
      local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })

      vim.keymap.set("n", "<leader>tt", function()
        float:toggle()
      end, { desc = "Floating terminal" })
      vim.keymap.set("n", "<leader>tl", function()
        lazygit:toggle()
      end, { desc = "Lazygit" })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>b", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<F5>", function() require("dap").continue() end, desc = "Debug continue" },
      { "<F6>", function() require("dap").step_into() end, desc = "Debug step into" },
      { "<F7>", function() require("dap").step_over() end, desc = "Debug step over" },
      { "<F8>", function() require("dap").step_out() end, desc = "Debug step out" },
      { "<F9>", function() require("dap").run_last() end, desc = "Debug run last" },
      { "<F10>", function() require("dap").terminate() end, desc = "Debug terminate" },
    },
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        opts = {},
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
      dap.listeners.before.event_terminated["dapui"] = dapui.close
      dap.listeners.before.event_exited["dapui"] = dapui.close

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
    end,
  },
}

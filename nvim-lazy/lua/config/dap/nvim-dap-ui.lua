local utils = require("utils")
local M = {
  requires = {
    "dapui",
    "dap",
  },
}

function M.before()
  -- M.register_key()
end

function M.load()
  M.dapui.setup({
    layouts = {
      {
        elements = {
          -- elements can be strings or table with id and size keys.
          "scopes",
          "breakpoints",
          "stacks",
          "watches",
        },
        size = 30,
        position = "left",
      },
      {
        elements = {
          "repl",
          "console",
        },
        size = 10,
        position = "bottom",
      },
    },
  })
  -- Automatically start dapui when debugging starts
  M.dap.listeners.after.event_initialized["dapui_config"] = function()
    ---@diagnostic disable-next-line: missing-parameter
    M.dapui.open()
  end
  -- Automatically close dapui and repl windows when debugging is closed
  M.dap.listeners.before.event_terminated["dapui_config"] = function()
    ---@diagnostic disable-next-line: missing-parameter
    M.dapui.close()
    M.dap.repl.close()
  end
  -- Automatically close dapui and repl windows when debugging is closed
  M.dap.listeners.before.event_exited["dapui_config"] = function()
    ---@diagnostic disable-next-line: missing-parameter
    M.dapui.close()
    M.dap.repl.close()
  end
end

function M.after() end

function M.register_key()
  utils.keymap.batch_register_in_mode({ "n" }, {
    {
      lhs = "<leader>du",
      rhs = function()
        ---@diagnostic disable-next-line: missing-parameter
        require("dapui").toggle()
      end,
      options = { silent = true },
      description = "Toggle debug ui",
    },
    {
      lhs = "<leader>de",
      rhs = function()
        for _, opts in ipairs(public.get_all_win_buf_ft()) do
          if opts.buf_ft == "dapui_hover" then
            ---@diagnostic disable-next-line: missing-parameter
            require("dapui").eval()
            return
          end
        end
        ---@diagnostic disable-next-line: missing-parameter
        require("dapui").eval(vim.fn.input("Enter debug expression: "))
      end,
      options = { silent = true },
      description = "Execute debug expressions",
    },
  })
end

return M

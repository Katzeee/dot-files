local icons = require("core.icons")

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  dependencies = { "CRAG666/code_runner.nvim" },
  keys = {
    { "<Tab>tt", desc = "Floating terminal" },
    { "<Tab>gg", desc = "Lazygit" },
  },
  config = function()
    require("toggleterm").setup({
      shade_terminals = true,
      shading_factor = 1,
      start_in_insert = true,
      persist_mode = false,
      float_opts = { border = icons.nerd and "double" or "none" },
    })

    local Terminal = require("toggleterm.terminal").Terminal
    local float = Terminal:new({
      count = 5,
      direction = "float",
      hidden = true,
      on_open = function(term)
        vim.keymap.set("t", "<Esc>", "<C-\\><C-n><cmd>close<cr>", {
          buffer = term.bufnr,
          silent = true,
          desc = "Close floating terminal",
        })
      end,
    })
    local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })

    require("code_runner").setup({
      mode = "toggleterm",
      filetype = {
        cpp = "cd $dir",
      },
    })

    vim.keymap.set("n", "<Tab>tt", function()
      float:toggle()
    end, { desc = "Floating terminal" })
    vim.keymap.set("n", "<Tab>gg", function()
      lazygit:toggle()
    end, { desc = "Lazygit" })
  end,
}

local icons = require("core.icons")

return {
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
}

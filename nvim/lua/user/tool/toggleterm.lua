local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
  return
end

-- vim.api.
--

vim.api.map.bulk_register({
  {
    mode = { "n" },
    lhs = "<leader>tt",
    rhs = function()
      require("toggleterm").term_toggle()
    end,
    options = { silent = true },
    description = "Toggle bottom or vertical terminal",
  },
  {
    mode = { "n" },
    lhs = "<leader>tf",
    rhs = function()
      require("toggleterm").float_toggle()
    end,
    options = { silent = true },
    description = "Toggle floating terminal",
  },
  {
    mode = { "n" },
    lhs = "<leader>tv",
    rhs = function()
      require("toggleterm").vertical_toggle()
    end,
    options = { silent = true },
    description = "Toggle vertical terminal",
  },
  {
    mode = { "n" },
    lhs = "<leader>tg",
    rhs = function()
      require("toggleterm").lazygit_toggle()
    end,
    options = { silent = true },
    description = "Toggle lazygit terminal",
  },
  {
    mode = { "n" },
    lhs = "<leader>ta",
    rhs = function()
      require("toggleterm").toggle_all_term()
    end,
    options = { silent = true },
    description = "Toggle all terminal",
  },
})


toggleterm.setup {
  open_mapping = [[<c-\]],
}

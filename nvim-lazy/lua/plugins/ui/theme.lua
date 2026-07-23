return {
  "sainnhe/everforest",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.everforest_background = "soft"
      -- Avoid generating an `after/` cache inside the configuration directory.
      -- This also keeps the config usable from read-only deployments.
      vim.g.everforest_better_performance = 0
    vim.o.background = "dark"
    vim.cmd.colorscheme("everforest")
  end,
}

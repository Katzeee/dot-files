local icons = require("core.icons")

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    win = { border = icons.profile.border },
    icons = {
      breadcrumb = icons.profile.which_key.breadcrumb,
      separator = icons.profile.which_key.separator,
      group = "+",
      ellipsis = icons.profile.which_key.ellipsis,
      mappings = icons.nerd,
      rules = icons.nerd and {} or false,
    },
    spec = {
      { "<leader>g", group = "Git" },
      { "<leader>l", group = "LSP" },
      { "<leader>s", group = "Search" },
      { "<leader>t", group = "Terminal" },
      { "<leader>d", group = "Debug" },
      { "<Tab>", group = "Views" },
    },
  },
}

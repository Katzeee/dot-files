local icons = require("core.icons")

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 500,
    sort = { "alphanum" },
    win = { border = icons.profile.border },
    icons = {
      breadcrumb = icons.profile.which_key.breadcrumb,
      separator = icons.profile.which_key.separator,
      group = "+",
      ellipsis = icons.profile.which_key.ellipsis,
      mappings = icons.nerd,
      rules = icons.nerd and {} or false,
      keys = icons.profile.which_key.keys,
    },
    spec = {
      { "<leader>b", group = "Debug" },
      { "<leader>d", group = "Debug" },
      { "<leader>e", group = "Diagnostics" },
      { "<leader>g", group = "Git" },
      { "<leader>i", group = "Incoming calls" },
      { "<leader>p", group = "Paste" },
      { "<leader>r", group = "Refactor" },
      { "<Tab>", group = "Commands" },
      { "<Tab>c", group = "Code" },
      { "<Tab>d", group = "Debug" },
      { "<Tab>g", group = "Git" },
      { "<Tab>t", group = "Terminal" },
    },
  },
}

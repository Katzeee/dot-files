local icons = require("core.icons")

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = icons.nerd and { "nvim-tree/nvim-web-devicons" } or nil,
  opts = {
    options = {
      theme = "everforest",
      icons_enabled = icons.nerd,
      component_separators = { left = icons.profile.separator, right = icons.profile.separator },
      section_separators = { left = "", right = "" },
    },
  },
}

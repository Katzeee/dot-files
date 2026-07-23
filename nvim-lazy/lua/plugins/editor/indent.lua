local icons = require("core.icons")

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    indent = { char = icons.profile.indent },
    scope = { enabled = true, show_start = true },
    exclude = {
      filetypes = { "help", "alpha", "dashboard", "lazy", "mason", "NvimTree" },
    },
  },
}

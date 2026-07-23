local icons = require("core.icons")

return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  version = "*",
  dependencies = icons.nerd and { "nvim-tree/nvim-web-devicons" } or nil,
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = true,
      get_element_icon = icons.nerd and nil or function()
        return icons.profile.bufferline.file
      end,
      buffer_close_icon = icons.profile.bufferline.close,
      close_icon = icons.profile.bufferline.close,
      separator_style = "thin",
      offsets = { { filetype = "NvimTree", text = "Explorer", separator = true } },
    },
  },
}

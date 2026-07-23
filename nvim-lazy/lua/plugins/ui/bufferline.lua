local icons = require("core.icons")

local function close_buffer(buffer)
  buffer = buffer == 0 and vim.api.nvim_get_current_buf() or buffer
  if not vim.api.nvim_buf_is_valid(buffer) or not vim.bo[buffer].buflisted then
    return
  end

  if vim.bo[buffer].modified then
    vim.notify("Save or discard changes before closing this buffer", vim.log.levels.WARN)
    return
  end

  if buffer == vim.api.nvim_get_current_buf() then
    vim.cmd("bnext")
  end
  vim.api.nvim_buf_delete(buffer, { force = false })
end

return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  version = "*",
  dependencies = icons.nerd and { "nvim-tree/nvim-web-devicons" } or nil,
  keys = {
    { "<C-w>", function() close_buffer(0) end, desc = "Close buffer", nowait = true },
    { "E", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
    { "R", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    { "<leader>t", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle buffer pin" },
  },
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      close_command = close_buffer,
      right_mouse_command = close_buffer,
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

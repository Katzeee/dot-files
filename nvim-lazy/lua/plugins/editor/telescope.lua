local icons = require("core.icons")

return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<Tab>b", "<cmd>Telescope buffers theme=dropdown previewer=false<cr>", desc = "Buffers" },
    { "<Tab>f", "<cmd>Telescope find_files theme=dropdown previewer=false<cr>", desc = "Find files" },
    { "<Tab>F", "<cmd>Telescope live_grep theme=ivy<cr>", desc = "Find text" },
    { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
    { "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
  },
  opts = function()
    local actions = require("telescope.actions")
    return {
      defaults = {
        prompt_prefix = icons.profile.telescope.prompt,
        selection_caret = icons.profile.telescope.selection,
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<Esc>"] = actions.close,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          },
        },
      },
    }
  end,
}

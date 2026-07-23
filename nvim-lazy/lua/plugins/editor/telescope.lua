local icons = require("core.icons")

return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-dap.nvim",
      dependencies = { "mfussenegger/nvim-dap" },
    },
  },
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
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<Esc>"] = actions.close,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-l>"] = actions.complete_tag,
            ["<C-_>"] = actions.which_key,
          },
        },
      },
    }
  end,
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("dap")
  end,
}

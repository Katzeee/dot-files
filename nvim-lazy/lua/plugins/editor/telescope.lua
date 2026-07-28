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
    { "<Tab><Tab>", "<cmd>Telescope commands<cr>", desc = "Commands" },
    { "<Tab>f", function() require("core.search").find_files() end, desc = "Find files" },
    { "<Tab>F", "<cmd>Telescope live_grep theme=ivy<cr>", desc = "Find text" },
    { "<Tab>w", "<cmd>Telescope grep_string<cr>", desc = "Search word" },
    { "<Tab>S", function() require("core.search").find_workspace_symbols() end, desc = "Workspace symbols" },
    { "<Tab>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
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

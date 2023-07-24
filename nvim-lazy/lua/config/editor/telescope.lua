local M = {
  requires = {
    "telescope",
    "telescope.actions",
  },
}

function M.before() end

function M.after() end

function M.load()
  -- print(vim.inspect(M))
  M.telescope.setup({
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      path_display = { "smart" },
      mappings = {
        i = {
          ["<C-n>"] = M.telescope_actions.cycle_history_next,
          ["<C-p>"] = M.telescope_actions.cycle_history_prev,
          ["<C-j>"] = M.telescope_actions.move_selection_next,
          ["<C-k>"] = M.telescope_actions.move_selection_previous,
          ["<esc>"] = M.telescope_actions.close,
          ["<Down>"] = M.telescope_actions.move_selection_next,
          ["<Up>"] = M.telescope_actions.move_selection_previous,
          ["<CR>"] = M.telescope_actions.select_default,
          ["<C-x>"] = M.telescope_actions.select_horizontal,
          ["<C-v>"] = M.telescope_actions.select_vertical,
          ["<C-t>"] = M.telescope_actions.select_tab,
          ["<C-u>"] = M.telescope_actions.preview_scrolling_up,
          ["<C-d>"] = M.telescope_actions.preview_scrolling_down,
          -- ["<PageUp>"] = actions.results_scrolling_up,
          -- ["<PageDown>"] = actions.results_scrolling_down,

          ["<Tab>"] = M.telescope_actions.toggle_selection + M.telescope_actions.move_selection_worse,
          ["<S-Tab>"] = M.telescope_actions.toggle_selection + M.telescope_actions.move_selection_better,
          ["<C-q>"] = M.telescope_actions.send_to_qflist + M.telescope_actions.open_qflist,
          ["<M-q>"] = M.telescope_actions.send_selected_to_qflist + M.telescope_actions.open_qflist,
          ["<C-l>"] = M.telescope_actions.complete_tag,
          ["<C-_>"] = M.telescope_actions.which_key, -- keys from pressing <C-/>
        },
        --     n = {
        --       ["<esc>"] = actions.close,
        --       ["<CR>"] = actions.select_default,
        --       ["<C-x>"] = actions.select_horizontal,
        --       ["<C-v>"] = actions.select_vertical,
        --       ["<C-t>"] = actions.select_tab,
        --
        --       ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        --       ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        --       ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        --       ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        --
        --       ["j"] = actions.move_selection_next,
        --       ["k"] = actions.move_selection_previous,
        --       ["H"] = actions.move_to_top,
        --       ["M"] = actions.move_to_middle,
        --       ["L"] = actions.move_to_bottom,
        --
        --       ["<Down>"] = actions.move_selection_next,
        --       ["<Up>"] = actions.move_selection_previous,
        --       ["gg"] = actions.move_to_top,
        --       ["G"] = actions.move_to_bottom,
        --
        --       ["<C-u>"] = actions.preview_scrolling_up,
        --       ["<C-d>"] = actions.preview_scrolling_down,
        --
        --       ["<PageUp>"] = actions.results_scrolling_up,
        --       ["<PageDown>"] = actions.results_scrolling_down,
        --
        --       ["?"] = actions.which_key,
        --     },
      },
    },
    pickers = {
      -- Default configuration for builtin pickers goes here:
      -- picker_name = {
      --   picker_config_key = value,
      --   ...
      -- }
      -- find_files = {
      --     theme = "dropdown",
      -- }
      -- Now the picker_config_key will be applied every time you call this
      -- builtin picker
      -- },
      -- extensions = {
      -- Your extension configuration goes here:
      -- extension_name = {
      --   extension_config_key = value,
    },
    -- please take a look at the readme of the extension you want to configure
    -- },
  })
  M.telescope.load_extension("dap")
end

return M

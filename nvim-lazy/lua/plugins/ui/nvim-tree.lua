local icons = require("core.icons")

return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFindFile" },
  keys = {
    { "<Tab>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
  },
  dependencies = icons.nerd and { "nvim-tree/nvim-web-devicons" } or nil,
  config = function(_, opts)
    require("nvim-tree").setup(opts)

    local group = vim.api.nvim_create_augroup("nvim_tree_layout", { clear = true })
    local filling_layout = false

    local function ensure_main_window()
      if filling_layout then
        return
      end

      local normal_windows = vim.tbl_filter(function(window)
        return vim.api.nvim_win_get_config(window).relative == ""
      end, vim.api.nvim_tabpage_list_wins(0))

      if #normal_windows ~= 1 then
        return
      end

      local tree_window = normal_windows[1]
      local tree_buffer = vim.api.nvim_win_get_buf(tree_window)
      if vim.bo[tree_buffer].filetype ~= "NvimTree" then
        return
      end

      filling_layout = true
      vim.wo[tree_window].winfixwidth = true
      vim.cmd("botright vnew")
      vim.api.nvim_win_set_width(tree_window, opts.view.width)
      vim.api.nvim_set_current_win(tree_window)
      filling_layout = false
    end

    local function schedule_layout_check()
      vim.schedule(ensure_main_window)
    end

    vim.api.nvim_create_autocmd("QuitPre", {
      group = group,
      callback = function()
        local current_window = vim.api.nvim_get_current_win()
        local normal_windows = vim.tbl_filter(function(window)
          return vim.api.nvim_win_get_config(window).relative == ""
        end, vim.api.nvim_tabpage_list_wins(0))

        if #normal_windows ~= 2 or vim.bo[vim.api.nvim_win_get_buf(current_window)].filetype == "NvimTree" then
          return
        end

        local companion_window = normal_windows[1] == current_window and normal_windows[2] or normal_windows[1]
        local companion_buffer = vim.api.nvim_win_get_buf(companion_window)
        if vim.bo[companion_buffer].filetype == "NvimTree" then
          require("nvim-tree.api").tree.close()
        end
      end,
    })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "NvimTree",
      callback = schedule_layout_check,
    })
    vim.api.nvim_create_autocmd("WinClosed", {
      group = group,
      callback = schedule_layout_check,
    })
  end,
  opts = {
    hijack_cursor = true,
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    view = { width = 32 },
    renderer = {
      group_empty = true,
      highlight_git = true,
      icons = {
        show = {
          git = true,
          folder = true,
          file = true,
          folder_arrow = true,
          modified = true,
        },
        glyphs = icons.profile.nvim_tree,
      },
    },
    filters = { dotfiles = false },
  },
}

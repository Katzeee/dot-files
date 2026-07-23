local icons = require("core.icons")
local devicons_dependency = icons.nerd and { "nvim-tree/nvim-web-devicons" } or nil

return {
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_background = "hard"
      vim.cmd.colorscheme("everforest")
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    enabled = icons.nerd,
    lazy = true,
  },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFindFile" },
    keys = {
      { "<Tab>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
    },
    dependencies = devicons_dependency,
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
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = devicons_dependency,
    opts = {
      options = {
        theme = "everforest",
        icons_enabled = icons.nerd,
        component_separators = { left = icons.profile.separator, right = icons.profile.separator },
        section_separators = { left = "", right = "" },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    version = "*",
    dependencies = devicons_dependency,
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
  },
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen", "AerialClose" },
    keys = {
      { "<Tab>o", "<cmd>AerialToggle<cr>", desc = "Outline" },
    },
    dependencies = devicons_dependency,
    opts = {
      backends = { "lsp", "treesitter", "markdown" },
      show_guides = true,
      layout = { min_width = 30, max_width = { 40, 0.2 } },
      nerd_font = icons.nerd,
      icons = icons.profile.aerial,
      keymaps = { o = "actions.scroll", h = "actions.tree_toggle" },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      win = { border = icons.profile.border },
      icons = {
        breadcrumb = icons.profile.which_key.breadcrumb,
        separator = icons.profile.which_key.separator,
        group = "+",
        ellipsis = icons.profile.which_key.ellipsis,
        mappings = icons.nerd,
        rules = icons.nerd and {} or false,
      },
      spec = {
        { "<leader>g", group = "Git" },
        { "<leader>l", group = "LSP" },
        { "<leader>s", group = "Search" },
        { "<leader>t", group = "Terminal" },
        { "<leader>d", group = "Debug" },
        { "<Tab>", group = "Views" },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = false,
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("<leader>gl", gs.toggle_current_line_blame, "Toggle line blame")
        map("<leader>gr", gs.reset_hunk, "Reset hunk")
        map("<leader>gR", gs.reset_buffer, "Reset buffer")
        map("<leader>gs", gs.stage_hunk, "Stage hunk")
        map("<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
      end,
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      popupmenu = { kind_icons = icons.nerd },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = icons.nerd,
      },
    },
  },
}

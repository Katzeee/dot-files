-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
vim.g.nvim_tree_icons = {
  default = "",
  symlink = "",
  git = {
    unstaged = "",
    staged = "S",
    unmerged = "",
    renamed = "➜",
    deleted = "",
    untracked = "U",
    ignored = "◌",
  },
  folder = {
    default = "",
    open = "",
    empty = "",
    empty_open = "",
    symlink = "",
  },
}

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

-- local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
-- if not config_status_ok then
--   return
-- end

local api_status_ok, nvim_tree_api = pcall(require, "nvim-tree.api")
if not api_status_ok then
  return
end

-- local tree_cb = nvim_tree_config.nvim_tree_callback

local function open_file_then_close_tree(node)
  nvim_tree_api.node.open.edit(node)
  -- nvim_tree_api.tree.close()
end

nvim_tree.setup {
  disable_netrw = true,
  hijack_netrw = true,
  -- ignore_ft_on_setup = {
  --   "startify",
  --   "dashboard",
  --   "alpha",
  -- },
  -- auto_close = true,
  open_on_tab = false,
  hijack_cursor = false,
  update_cwd = true,
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  system_open = {
    cmd = nil,
    args = {},
  },
  filters = {
    dotfiles = false,
    custom = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  view = {
    width = 30,
    hide_root_folder = false,
    side = "left",
    mappings = {
      custom_only = false,
      list = {
        { key = "<tab>e", action = "close" },
        { key = "o", action = "preview" },
        { key = { "<CR>" }, action = "oftct", action_cb = open_file_then_close_tree }, -- arbitrary name of action
        { key = "h", action = "close_node" },
        { key = "v", action = "vsplit" },
      },
    },
    number = false,
    relativenumber = false,
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
}

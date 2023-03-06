local M = {
  requires = {
    "nvim-tree",
  },
}

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

local api_status_ok, nvim_tree_api = pcall(require, "nvim-tree.api")
if not api_status_ok then
  return
end

local function open_file_then_close_tree(node)
  nvim_tree_api.node.open.edit(node)
  -- nvim_tree_api.tree.close()
end

local function open_folder_or_preview(node)
  if node.name == ".." then
    require("nvim-tree.actions.root.change-dir").fn ".."
  elseif node.nodes then
    require("nvim-tree.lib").expand_or_collapse(node)
  else
    local path = node.absolute_path
    if node.link_to and not node.nodes then
      path = node.link_to
    end
    require("nvim-tree.actions.node.open-file").fn("preview", path)
  end
end

function M.before()
end

function M.load()
  M.nvim_tree.setup {
    disable_netrw = true,
    hijack_netrw = true,
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
          { key = "<tab>e",   action = "close" },
          { key = "o",        action = "ofop",  action_cb = open_folder_or_preview },
          { key = { "<CR>" }, action = "oftct", action_cb = open_file_then_close_tree }, -- arbitrary name of action
          -- { key = "h",        action = "close_node" },
          { key = "v",        action = "vsplit" },
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
end

function M.after()
end

return M

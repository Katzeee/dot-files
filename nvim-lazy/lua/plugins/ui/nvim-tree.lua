local icons = require("core.icons")

local function filesystem_watchers_enabled()
  local settings = require("core.project.config").get().values.nvim_tree
  return type(settings) ~= "table" or settings.filesystem_watchers ~= false
end

local function on_attach(buffer)
  local api = require("nvim-tree.api")
  api.config.mappings.default_on_attach(buffer)
  vim.keymap.del("n", "<Tab>", { buffer = buffer })

  local function opts(desc)
    return { buffer = buffer, desc = "nvim-tree: " .. desc, nowait = true, silent = true }
  end

  vim.keymap.set("n", "<Tab>e", api.tree.close, opts("Close"))
  vim.keymap.set("n", "o", function()
    local node = api.tree.get_node_under_cursor()
    if node and (node.name == ".." or node.nodes) then
      api.node.open.edit()
    else
      api.node.open.preview()
    end
  end, opts("Expand folder or preview file"))
  vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
  vim.keymap.set("n", "v", api.node.open.vertical, opts("Open in vertical split"))
end

return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFindFile" },
  keys = {
    { "<Tab>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
  },
  dependencies = icons.nerd and { "nvim-tree/nvim-web-devicons" } or nil,
  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts, {
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = false,
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      filesystem_watchers = {
        enable = filesystem_watchers_enabled(),
      },
      on_attach = on_attach,
      diagnostics = {
        enable = true,
        icons = {
          hint = icons.profile.diagnostic.hint,
          info = icons.profile.diagnostic.info,
          warning = icons.profile.diagnostic.warn,
          error = icons.profile.diagnostic.error,
        },
      },
      git = {
        enable = true,
        ignore = false,
        timeout = 500,
      },
      view = {
        width = 30,
        side = "left",
        number = false,
        relativenumber = false,
      },
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
      filters = {
        dotfiles = false,
        custom = {},
      },
      trash = {
        cmd = "trash",
        require_confirm = true,
      },
    })
  end,
}

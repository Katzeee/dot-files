local icons = require("core.icons")

return {
  "stevearc/aerial.nvim",
  cmd = { "AerialToggle", "AerialOpen", "AerialClose" },
  keys = {
    { "<Tab>o", "<cmd>AerialToggle<cr>", desc = "Outline" },
  },
  dependencies = icons.nerd and { "nvim-tree/nvim-web-devicons" } or nil,
  opts = {
    backends = { "lsp", "treesitter", "markdown" },
    show_guides = true,
    update_events = "TextChanged,InsertLeave",
    layout = { min_width = 30, max_width = { 40, 0.2 } },
    lsp = {
      diagnostics_trigger_update = false,
      update_when_errors = true,
      update_delay = 300,
    },
    filter_kind = {
      "Module",
      "Struct",
      "Interface",
      "Class",
      "Constructor",
      "Enum",
      "Function",
      "Method",
    },
    nerd_font = icons.nerd,
    icons = icons.profile.aerial,
    keymaps = { o = "actions.scroll", h = "actions.tree_toggle" },
  },
}

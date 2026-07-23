local icons = require("core.icons")

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    cmdline = {
      format = {
        cmdline = { icon = icons.profile.noice.cmdline },
        search_down = { icon = icons.profile.noice.search_down },
        search_up = { icon = icons.profile.noice.search_up },
        filter = { icon = icons.profile.noice.filter },
        lua = { icon = icons.profile.noice.lua },
        help = { icon = icons.profile.noice.help },
        calculator = { icon = icons.profile.noice.calculator },
        input = { icon = icons.profile.noice.input },
      },
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    popupmenu = { kind_icons = icons.nerd },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = icons.nerd,
    },
  },
}

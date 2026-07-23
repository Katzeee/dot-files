local icons = require("core.icons")

local function hide_in_narrow_window()
  return vim.fn.winwidth(0) > 80
end

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = {
    error = icons.profile.diagnostic.error .. " ",
    warn = icons.profile.diagnostic.warn .. " ",
  },
  colored = false,
  update_in_insert = false,
  always_visible = true,
}

local branch = {
  "branch",
  icons_enabled = icons.nerd,
  icon = icons.profile.lualine.branch,
}

local diff = {
  "diff",
  colored = false,
  symbols = {
    added = icons.profile.lualine.added .. " ",
    modified = icons.profile.lualine.modified .. " ",
    removed = icons.profile.lualine.removed .. " ",
  },
  cond = hide_in_narrow_window,
}

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = icons.nerd and { "nvim-tree/nvim-web-devicons" } or nil,
  opts = {
    options = {
      theme = "auto",
      icons_enabled = icons.nerd,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "dashboard", "alpha", "NvimTree", "Outline", "aerial" },
      always_divide_middle = true,
    },
    sections = {
      lualine_a = { branch, diagnostics },
      lualine_b = {
        {
          "mode",
          fmt = function(value)
            return "-- " .. value .. " --"
          end,
        },
      },
      lualine_c = {},
      lualine_x = {
        diff,
        "aerial",
        function()
          return "spaces: " .. vim.bo.shiftwidth
        end,
        "encoding",
        { "filetype", icons_enabled = false },
      },
      lualine_y = { { "location", padding = 0 } },
      lualine_z = { "progress" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
  },
}

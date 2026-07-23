local icons = require("core.icons")

return {
  "mason-org/mason.nvim",
  cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
  build = ":MasonUpdate",
  opts = {
    ui = {
      border = icons.profile.border,
      icons = icons.profile.mason,
    },
    max_concurrent_installers = 4,
  },
}

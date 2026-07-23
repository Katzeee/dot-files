local M = {}

local supported = {
  ascii = true,
  unicode = true,
  nerd = true,
}

local default_mode = "unicode"
local requested = (vim.env.NVIM_ICON_MODE or default_mode):lower()
if not supported[requested] then
  local invalid_mode = requested
  vim.schedule(function()
    vim.notify(
      ("Invalid NVIM_ICON_MODE=%q; using the %s profile"):format(invalid_mode, default_mode),
      vim.log.levels.WARN,
      { title = "Neovim icons" }
    )
  end)
  requested = default_mode
end

local layers = {
  require("core.icons.profiles.ascii"),
}
if requested == "unicode" or requested == "nerd" then
  layers[#layers + 1] = require("core.icons.profiles.unicode")
end
if requested == "nerd" then
  layers[#layers + 1] = require("core.icons.profiles.nerd")
end

M.profile = vim.tbl_deep_extend("force", {}, unpack(layers))
M.mode = M.profile.name
M.unicode = M.profile.has_unicode
M.nerd = M.profile.has_nerd_font

-- This conventional capability flag is consumed by several plugins.
vim.g.have_nerd_font = M.nerd

function M.info()
  local next_mode = ({ ascii = "unicode", unicode = "nerd", nerd = "ascii" })[M.mode]
  local description = ({
    ascii = "ASCII-safe rendering is enabled.",
    unicode = "Common Unicode symbols are enabled.",
    nerd = "Nerd Font glyphs are enabled.",
  })[M.mode]
  return {
    ("Icon mode: %s"):format(M.mode),
    description,
    ("Switch on next launch: NVIM_ICON_MODE=%s nvim"):format(next_mode),
  }
end

vim.api.nvim_create_user_command("IconInfo", function()
  vim.notify(table.concat(M.info(), "\n"), vim.log.levels.INFO, { title = "Neovim icons" })
end, { desc = "Show the active icon capability mode" })

return M

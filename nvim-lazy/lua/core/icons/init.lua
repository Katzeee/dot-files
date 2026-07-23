local M = {}

local supported = {
  ascii = true,
  nerd = true,
}

local requested = (vim.env.NVIM_ICON_MODE or "ascii"):lower()
if not supported[requested] then
  local invalid_mode = requested
  vim.schedule(function()
    vim.notify(
      ("Invalid NVIM_ICON_MODE=%q; using the ASCII-safe profile"):format(invalid_mode),
      vim.log.levels.WARN,
      { title = "Neovim icons" }
    )
  end)
  requested = "ascii"
end

M.profile = require("core.icons.profiles." .. requested)
M.mode = M.profile.name
M.nerd = M.profile.has_nerd_font

-- This conventional capability flag is consumed by several plugins.
vim.g.have_nerd_font = M.nerd

function M.info()
  local next_mode = M.nerd and "ascii" or "nerd"
  return {
    ("Icon mode: %s"):format(M.mode),
    M.nerd and "Nerd Font glyphs are enabled." or "ASCII-safe rendering is enabled.",
    ("Switch on next launch: NVIM_ICON_MODE=%s nvim"):format(next_mode),
  }
end

vim.api.nvim_create_user_command("IconInfo", function()
  vim.notify(table.concat(M.info(), "\n"), vim.log.levels.INFO, { title = "Neovim icons" })
end, { desc = "Show the active icon capability mode" })

return M

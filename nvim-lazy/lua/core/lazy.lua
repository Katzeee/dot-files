local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local icons = require("core.icons")

if not vim.uv.fs_stat(lazypath) then
  local result = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Failed to install lazy.nvim:\n" .. result)
  end
end

vim.opt.rtp:prepend(lazypath)

require("core.dependencies").setup()

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = { lazy = true },
  install = { colorscheme = { "everforest", "habamax" } },
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  ui = {
    border = icons.profile.border,
    icons = icons.profile.lazy,
  },
})

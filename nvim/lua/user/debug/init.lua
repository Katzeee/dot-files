local M = {}

local debuggers = {
  "nvim-gdb"
}

M.setup = function()
  for _, debugger in pairs(debuggers) do
    local require_ok, _ = pcall(require, "user.debug.settings." .. debugger)
    if not require_ok then
      vim.notify("Failed loading " .. debugger, vim.log.level.ERROR)
    end
  end
end

M.setup()

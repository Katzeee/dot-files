local directory_arg = vim.fn.argc() == 1 and vim.fn.argv(0) or nil
local started_with_directory = directory_arg ~= nil and vim.fn.isdirectory(directory_arg) == 1

local function open_project_tree()
  local api = require("nvim-tree.api")
  api.tree.open()
  api.tree.change_root(vim.fn.getcwd())
  api.tree.reload()
end

return {
  "rmagatti/auto-session",
  lazy = false,
  init = function()
    if started_with_directory then
      vim.cmd.cd(vim.fs.normalize(vim.fn.fnamemodify(directory_arg, ":p")))
    end
  end,
  opts = {
    post_restore_cmds = { open_project_tree },
    no_restore_cmds = {
      function(is_startup)
        if is_startup and started_with_directory then
          open_project_tree()
        end
      end,
    },
  },
}

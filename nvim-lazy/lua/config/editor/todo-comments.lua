local M = {
  requires = {
    "todo-comments",
  },
}

function M.before() end

function M.load()
  M.todo_comments.setup({
    signs = false,
    gui_style = {
      fg = "NONE",
      bg = "NONE",
      gui = "NONE",
    },
  })
end

function M.after() end

return M

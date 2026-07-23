return {
  "folke/todo-comments.nvim",
  cmd = { "TodoTelescope", "TodoQuickFix" },
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = { signs = false },
}

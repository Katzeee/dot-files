return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    current_line_blame = false,
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
      end
      map("<leader>gl", gs.toggle_current_line_blame, "Toggle line blame")
      map("<leader>gr", gs.reset_hunk, "Reset hunk")
      map("<leader>gR", gs.reset_buffer, "Reset buffer")
      map("<leader>gs", gs.stage_hunk, "Stage hunk")
      map("<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
    end,
  },
}

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    current_line_blame = false,
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "-" },
      topdelete = { text = "-" },
      changedelete = { text = "_" },
    },
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 100,
      ignore_whitespace = false,
    },
    preview_config = {
      border = "single",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
      end
      map("<leader>gk", function()
        if vim.wo.diff then
          return
        end
        gs.nav_hunk("prev")
      end, "Previous hunk")
      map("<leader>gj", function()
        if vim.wo.diff then
          return
        end
        gs.nav_hunk("next")
      end, "Next hunk")
      map("<leader>gg", gs.preview_hunk, "Preview hunk")
      map("<leader>gb", gs.blame_line, "Blame line")
      map("<leader>gl", gs.toggle_current_line_blame, "Toggle line blame")
      map("<leader>gr", gs.reset_hunk, "Reset hunk")
      map("<leader>gR", gs.reset_buffer, "Reset buffer")
      map("<leader>gs", gs.stage_hunk, "Stage hunk")
      map("<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
    end,
  },
}

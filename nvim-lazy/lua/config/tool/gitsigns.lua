local utils = require("utils")

local M = {
  requires = {
    "gitsigns",
  },
}

function M.before()
end

function M.load()
  M.gitsigns.setup({
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    ---@diagnostic disable-next-line: unused-local
    on_attach = function(bufnr)
      M.register_key(bufnr)
    end,
    signs = {
      add = {
        hl = "GitSignsAdd",
        text = "+",
        numhl = "GitSignsAddNr",
        linehl = "GitSignsAddLn",
      },
      change = {
        hl = "GitSignsChange",
        text = "~",
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn",
      },
      delete = {
        hl = "GitSignsDelete",
        text = "-",
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn",
      },
      topdelete = {
        hl = "GitSignsDelete",
        text = "‾",
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn",
      },
      changedelete = {
        hl = "GitSignsChange",
        text = "_",
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn",
      },
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
  })
end

function M.after()
end

function M.register_key(bufnr)
  local opts = { silent = true, noremap = true, buffer = bufnr }
  utils.keymap.batch_register_in_mode({ "n" }, {
    {
      lhs = "<leader>gk",
      rhs = function()
        if vim.wo.diff then
          return "<leader>gk"
        end
        vim.schedule(function()
          M.gitsigns.prev_hunk()
        end)
        return "<Ignore>"
      end,
      options = { silent = true, expr = true, buffer = bufnr },
      desc = "Jump to the prev hunk",
    },
    {
      lhs = "<leader>gj",
      rhs = function()
        if vim.wo.diff then
          return "<leader>gj"
        end
        vim.schedule(function()
          M.gitsigns.next_hunk()
        end)
        return "<Ignore>"
      end,
      options = { silent = true, expr = true, buffer = bufnr },
      desc = "Jump to the next hunk",
    },
    {
      lhs = "<leader>gg",
      rhs = "<cmd>lua require'gitsigns'.preview_hunk()<CR>",
      options = opts,
      desc = "Preview this hunk",
    },
    {
      lhs = "<leader>gb",
      rhs = "<cmd>lua require 'gitsigns'.blame_line()<cr>",
      options = opts,
      desc = "Show blame line",
    },

  })
end

return M

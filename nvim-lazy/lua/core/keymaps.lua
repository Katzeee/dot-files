local utils = require("utils")
-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
--   operation_mode = "o"

local opts = { noremap = true, silent = true }
--Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

utils.keymap.register({
  mode = { "n", "v", "x", "t", "c" },
  lhs = "<Space>",
  rhs = "<Nop>",
  options = opts,
  desc = "Leader key",
})

utils.keymap.batch_register_in_mode({ "" }, {
  {
    lhs = "<S-h>",
    rhs = "0",
    options = opts,
    desc = "Eazy line navigation",
  },
  {
    lhs = "<S-l>",
    rhs = "$",
    options = opts,
    desc = "Eazy line navigation",
  },
})

utils.keymap.batch_register_in_mode({ "n" }, {
  {
    lhs = "<",
    rhs = "v<gv<Esc>",
    options = opts,
    desc = "Indent",
  },
  {
    lhs = ">",
    rhs = "v>gv<Esc>",
    options = opts,
    desc = "Indent",
  },
  {
    lhs = "<C-h>",
    rhs = "<C-w>h",
    options = opts,
    desc = "Better window navigation",
  },
  {
    lhs = "<C-j>",
    rhs = "<C-w>j",
    options = opts,
    desc = "Better window navigation",
  },
  {
    lhs = "<C-k>",
    rhs = "<C-w>k",
    options = opts,
    desc = "Better window navigation",
  },
  {
    lhs = "<C-l>",
    rhs = "<C-w>l",
    options = opts,
    desc = "Better window navigation",
  },
  {
    lhs = "<C-Up>",
    rhs = ":resize -2<CR>",
    options = opts,
    desc = "Resize with arrow",
  },
  {
    lhs = "<C-Down>",
    rhs = ":resize +2<CR>",
    options = opts,
    desc = "Resize with arrow",
  },
  {
    lhs = "<C-Left>",
    rhs = ":vertical resize -2<CR>",
    options = opts,
    desc = "Resize with arrow",
  },
  {
    lhs = "<C-Right>",
    rhs = ":vertical resize +2<CR>",
    options = opts,
    desc = "Resize with arrow",
  },
  {
    lhs = "gw",
    rhs = "*N",
    options = opts,
    desc = "Search word under cursor",
  },
})

utils.keymap.batch_register_in_mode({ "v" }, {
  {
    lhs = "<",
    rhs = "<gv",
    options = opts,
    desc = "Indent",
  },
  {
    lhs = ">",
    rhs = ">gv",
    options = opts,
    desc = "Indent",
  },
})

utils.keymap.batch_register_in_mode({ "i" }, {
  {
    lhs = "jk",
    rhs = "<ESC>",
    options = opts,
    desc = "Escape insert",
  },
})

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
map({ "n", "v", "o" }, "H", "0", { desc = "Line start" })
map({ "n", "v", "o" }, "L", "$", { desc = "Line end" })
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("n", "gw", "*N", { desc = "Search word under cursor" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-Up>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Down>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

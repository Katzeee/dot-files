vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
map({ "n", "v", "o" }, "H", "0", { desc = "Line start" })
map({ "n", "v", "o" }, "L", "$", { desc = "Line end" })
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("n", "gw", "*N", { desc = "Search word under cursor" })
map("n", "n", "nzz", { desc = "Next search result" })
map("n", "N", "Nzz", { desc = "Previous search result" })
map("n", ">", ">>", { desc = "Indent line" })
map("n", "<", "<<", { desc = "Outdent line" })

map("n", "<leader>p'", "vi'p", { desc = "Paste inside single quotes" })
map("n", '<leader>p"', 'vi"p', { desc = "Paste inside double quotes" })
map("n", "<leader>p(", "vi(p", { desc = "Paste inside parentheses" })

map("n", "<Tab>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<Tab>q", function()
  for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buffer = vim.api.nvim_win_get_buf(window)
    if vim.bo[buffer].buftype ~= "" then
      pcall(vim.api.nvim_win_close, window, false)
    end
  end
end, { desc = "Close auxiliary windows" })

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

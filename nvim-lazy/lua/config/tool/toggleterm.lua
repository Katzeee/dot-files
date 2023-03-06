
local M = {
  requires = {
    "toggleterm",
  },
}

function M.before() end
function M.load() end
function M.after() end


local Terminal = require "toggleterm.terminal".Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
local opt = {noremap = true, silent = true}

vim.api.nvim_set_keymap("n", "<C-\\>", "<cmd>lua lazygit:toggle()<CR>", opt)


require "utils.api.map".bulk_register({
  {
    mode = { "n" },
    lhs = "<leader>tt",
    rhs = function()
      require("toggleterm").term_toggle()
    end,
    options = { silent = true },
    description = "Toggle bottom or vertical terminal",
  },
  {
    mode = { "n" },
    lhs = "<leader>tf",
    rhs = function()
      require("toggleterm").float_toggle()
    end,
    options = { silent = true },
    description = "Toggle floating terminal",
  },
  {
    mode = { "n" },
    lhs = "<leader>tv",
    rhs = function()
      require("toggleterm").vertical_toggle()
    end,
    options = { silent = true },
    description = "Toggle vertical terminal",
  },
  {
    mode = { "n" },
    lhs = "<leader>tg",
    rhs = function()
      require("toggleterm").lazygit_toggle()
    end,
    options = { silent = true },
    description = "Toggle lazygit terminal",
  },
  {
    mode = { "n" },
    lhs = "<leader>ta",
    rhs = function()
      require("toggleterm").toggle_all_term()
    end,
    options = { silent = true },
    description = "Toggle all terminal",
  },
})


toggleterm.setup {
  open_mapping = [[<c-\]],
}

return M
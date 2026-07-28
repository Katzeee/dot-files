return {
  "folke/flash.nvim",
  keys = {
    {
      "f",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
  },
  opts = {
    modes = {
      char = {
        enabled = false,
      },
    },
  },
}

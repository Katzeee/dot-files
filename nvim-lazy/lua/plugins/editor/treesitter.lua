return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = function()
      -- Neovim ships parsers and matching queries for C, Lua, Markdown, Vim,
      -- Vimdoc, and query files. Do not shadow those parsers with independently
      -- versioned nvim-treesitter builds.
      local parsers = { "bash", "cpp", "json", "python", "rust" }
      require("nvim-treesitter").update(parsers):wait(300000)
      require("nvim-treesitter").install(parsers):wait(300000)
    end,
    config = function()
      require("nvim-treesitter").setup({})

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
  },
}

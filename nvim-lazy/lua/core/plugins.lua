local status_ok, lazy = pcall(require, "core.lazy")
if not status_ok then
  return
end

local M = {}

M.basic = {
  {
    "nvim-lua/popup.nvim", -- An implementation of the Popup API from vim in Neovim
    lazy = true,
  },
  {
    "nvim-lua/plenary.nvim", -- Useful lua functions used by lots of plugins
    lazy = true,
  }
}

M.theme = {
  {
    "lunarvim/darkplus.nvim"
  },
}

M.cmp = {
  {
    "hrsh7th/nvim-cmp",               -- The completion plugin
    dependencies = {
      { "hrsh7th/cmp-buffer" },       -- buffer completions
      { "hrsh7th/cmp-path" },         -- path completions
      { "hrsh7th/cmp-cmdline" },      -- cmdline completions
      { "saadparwaiz1/cmp_luasnip" }, -- snippet completions
      { "hrsh7th/cmp-nvim-lsp" },     -- cmp support lsp
    },
    event = { "InsertEnter", "CmdlineEnter" },
  },
  {
    "L3MON4D3/LuaSnip",
    -- in nvim-cmp config file require luasnip
    lazy = true,
    dependencies = {
      { "rafamadriz/friendly-snippets" },
    },
  },
}

M.lsp = {
  {
    "neovim/nvim-lspconfig",                   -- enable LSP
    event = { "VimEnter" },
    dependencies = {
      { "williamboman/mason-lspconfig.nvim" }, -- LSP installer
    },
  },
  {
    "williamboman/mason.nvim", -- LSP installer
    event = { "VimEnter" },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "UIEnter" },
  },
  {
    "folke/neodev.nvim", -- complete nvim functions
    lazy = true,
  },
  {
    "ray-x/lsp_signature.nvim", -- signature
    event = { "VimEnter" },
  },
}

M.dap = {

}

M.editor = {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      { "mrjones2014/nvim-ts-rainbow" },
      { "windwp/nvim-ts-autotag" },
      { "JoosepAlviste/nvim-ts-context-commentstring" },
      { "nvim-lua/plenary.nvim" },
    },
    event = { "UIEnter" },
  },

  {
    "nvim-telescope/telescope.nvim", -- find files and words
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
  },
  {
    "numToStr/Comment.nvim", -- comment line
    event = { "VeryLazy" },
  },
  {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
  },
}

M.tool = {
  {
    "folke/which-key.nvim",
    event = { "VeryLazy" },
  },
  {
    "akinsho/toggleterm.nvim",
    lazy = true,
  },
}

M.view = {
  {
    "nvim-tree/nvim-tree.lua", -- tree explorer
    -- lazy = true,
  },
  {
    "nvim-lualine/lualine.nvim", -- status line
    event = { "UIEnter" },
  },
  {
    "akinsho/bufferline.nvim",
    event = { "UIEnter" },
  },
}

lazy.entry(M)

return M

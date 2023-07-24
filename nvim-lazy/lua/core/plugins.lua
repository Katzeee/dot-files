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
  -- {
  -- 	"nvim-lua/plenary.nvim", -- Useful lua functions used by lots of plugins
  -- 	lazy = true,
  -- },
  {
    "nvim-tree/nvim-web-devicons",
    event = { "VimEnter" },
  },
}

M.theme = {
  {
    "lunarvim/darkplus.nvim",
  },
  {
    "sainnhe/everforest",
  },
}

M.cmp = {
  {
    "hrsh7th/nvim-cmp",            -- The completion plugin
    dependencies = {
      { "hrsh7th/cmp-buffer" },    -- buffer completions
      { "hrsh7th/cmp-path" },      -- path completions
      { "hrsh7th/cmp-cmdline" },   -- cmdline completions
      { "saadparwaiz1/cmp_luasnip" }, -- snippet completions
      { "hrsh7th/cmp-nvim-lsp" },  -- cmp support lsp
    },
    event = { "InsertEnter", "CmdlineEnter" },
  },
  {
    "L3MON4D3/LuaSnip",
    -- snippte engine
    lazy = true,
    dependencies = {
      { "rafamadriz/friendly-snippets" },
    },
  },
}

M.lsp = {
  {
    "neovim/nvim-lspconfig",                -- enable LSP
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
  -- {
  -- 	"sakhnik/nvim-gdb",
  -- 	build = "./install.sh",
  -- },
  {
    "mfussenegger/nvim-dap",
    lazy = true,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    event = { "UIEnter" },
  },
  {
    "rcarriga/nvim-dap-ui",
    event = { "VeryLazy" },
    version = "v3.2.3", -- https://github.com/rcarriga/nvim-dap-ui/issues/227
  },
}

M.editor = {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      { "mrjones2014/nvim-ts-rainbow" },
      -- { "windwp/nvim-ts-autotag" },
      -- { "JoosepAlviste/nvim-ts-context-commentstring" },
      { "nvim-lua/plenary.nvim" },
    },
    event = { "UIEnter" },
  },

  {
    "nvim-telescope/telescope.nvim", -- find files and words
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-dap.nvim" },
    },
  },
  {
    "numToStr/Comment.nvim", -- comment line
    event = { "VeryLazy" },
  },
  {
    "windwp/nvim-autopairs", -- autopair
    event = { "InsertEnter" },
  },
  {
    "stevearc/aerial.nvim", -- outline
    event = { "UIEnter" },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "UIEnter" },
  },
  {
    "folke/todo-comments.nvim", -- todo highlight
    event = { "UIEnter" },
  },
  {
    "mg979/vim-visual-multi", -- multi cursor
    event = { "VeryLazy" },
  },
}

M.tool = {
  {
    "folke/which-key.nvim",
    event = { "VeryLazy" },
    dependencies = {
      "akinsho/toggleterm.nvim",
    },
  },
  {
    "akinsho/toggleterm.nvim",
    dependencies = {
      "CRAG666/code_runner.nvim",
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "UIEnter" },
  },
}

M.view = {
  {
    "goolord/alpha-nvim",
    event = { "VimEnter" },
  },
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
  {
    "folke/noice.nvim", -- better notice
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    event = "VeryLazy",
  },
  {
    "goolord/alpha-nvim", -- dash board
    event = { "VimEnter" },
  },
}

lazy.entry(M)

return M

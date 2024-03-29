local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim"    -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim"  -- Useful lua functions used by lots of plugins

  -- Colorschemes
  -- use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
  use "lunarvim/darkplus.nvim"

  -- cmp plugins
  use "hrsh7th/nvim-cmp"         -- The completion plugin
  use "hrsh7th/cmp-buffer"       -- buffer completions
  use "hrsh7th/cmp-path"         -- path completions
  use "hrsh7th/cmp-cmdline"      -- cmdline completions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lsp"     -- cmp support lsp

  -- snippets
  use "L3MON4D3/LuaSnip"             --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- LSP
  use "neovim/nvim-lspconfig"             -- enable LSP
  use "williamboman/mason.nvim"           -- simple to use language server installer
  use "williamboman/mason-lspconfig.nvim" -- simple to use language server installer
  use "jose-elias-alvarez/null-ls.nvim"   -- LSP diagnostics and code actions
  -- use "p00f/clangd_extensions.nvim" -- LSP clangd extension
  use "lvimuser/lsp-inlayhints.nvim"      -- temp solution of inlay hints
  use "ray-x/lsp_signature.nvim"          -- signature
  use "folke/neodev.nvim"                 -- complete nvim functions


  -- other
  use "folke/which-key.nvim"                                 -- which key
  use "kyazdani42/nvim-tree.lua"                             -- tree explorer
  use "nvim-telescope/telescope.nvim"                        -- telescope for find files and words
  use {
    "nvim-lualine/lualine.nvim",                             -- status line
    requires = { "kyazdani42/nvim-web-devicons", opt = true } -- icons
  }
  use "numToStr/Comment.nvim"                                -- comment line
  use "windwp/nvim-autopairs"                                -- autopair
  use "akinsho/bufferline.nvim"                              -- tabs
  use "akinsho/toggleterm.nvim"                              -- terminal

  -- syntax highligh
  use "kyazdani42/nvim-web-devicons"
  use "nvim-treesitter/nvim-treesitter" -- syntax highlight
  use "p00f/nvim-ts-rainbow"

  -- Debug
  use {
    "sakhnik/nvim-gdb",
    run = "./install.sh"
  }


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)

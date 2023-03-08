local M = {
  requires = {
    "nvim-treesitter.configs",
    "nvim-treesitter.install"
  }
}

function M.before()
  vim.o.foldmethod = 'expr'
  vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
  vim.cmd [[set nofoldenable]]
end

function M.after()
end

function M.load()
  -- M.nvim_treesitter_install.prefer_git = true
  M.nvim_treesitter_configs.setup {
    ensure_installed = {
      "c", "cpp", "lua", "c_sharp", "python"
    },                       -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    sync_install = false,    -- install languages synchronously (only applied to `ensure_installed`)
    ignore_install = { "" }, -- List of parsers to ignore installing
    autopairs = {
      enable = true,
    },
    highlight = {
      enable = true,    -- false will disable the whole extension
      disable = { "" }, -- list of language that will be disabled
      additional_vim_regex_highlighting = true,
    },
    indent = { enable = true, disable = { "yaml" } },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = 1000,
    }
  }
end

return M

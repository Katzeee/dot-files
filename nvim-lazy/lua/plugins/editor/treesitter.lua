local install_dir = vim.fn.stdpath("data") .. "/treesitter"

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      local treesitter = require("nvim-treesitter")
      treesitter.setup({ install_dir = install_dir })

      -- Mason owns the portable CLI; nvim-treesitter owns parser compilation.
      -- Waiting for the Mason callback avoids a first-start installation race.
      require("core.toolchain").ensure("tree-sitter-cli", function(success, err)
        if not success then
          vim.notify(
            ("Unable to prepare tree-sitter-cli: %s"):format(err or "unknown error"),
            vim.log.levels.ERROR
          )
          return
        end

        -- Neovim already bundles C, Lua, Markdown, Vim, Vimdoc, and query
        -- parsers together with matching runtime queries.
        local wanted = { "bash", "cpp", "json", "python", "rust" }
        local installed = {}
        for _, parser in ipairs(treesitter.get_installed()) do
          installed[parser] = true
        end

        local missing = vim.tbl_filter(function(parser)
          return not installed[parser]
        end, wanted)

        if #missing > 0 then
          treesitter.install(missing, { summary = true })
        end
      end)

      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldenable = false

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
          if vim.bo[args.buf].filetype ~= "yaml" then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
  },
}

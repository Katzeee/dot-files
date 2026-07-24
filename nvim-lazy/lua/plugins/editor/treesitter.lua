local install_dir = vim.fn.stdpath("data") .. "/treesitter"
local wanted = { "bash", "cpp", "c_sharp", "json", "lua", "python", "rust" }

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    dependencies = { "mason-org/mason.nvim" },
    init = function()
      local mason = require("core.dependencies.providers.mason")

      require("core.dependencies").register("nvim-treesitter", {
        requires = {
          mason.package({
            package = "tree-sitter-cli",
            attempts = 2,
            retry_delay_ms = 500,
          }),
        },
        on_ready = function()
          local treesitter = require("nvim-treesitter")
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
        end,
      })
    end,
    config = function()
      local treesitter = require("nvim-treesitter")
      treesitter.setup({ install_dir = install_dir })

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

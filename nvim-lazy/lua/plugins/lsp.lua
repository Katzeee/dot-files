local icons = require("core.icons")

return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = icons.profile.border,
        icons = icons.profile.mason,
      },
      max_concurrent_installers = 4,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
        update_in_insert = false,
        float = { border = icons.profile.border, source = true },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icons.profile.diagnostic.error,
            [vim.diagnostic.severity.WARN] = icons.profile.diagnostic.warn,
            [vim.diagnostic.severity.INFO] = icons.profile.diagnostic.info,
            [vim.diagnostic.severity.HINT] = icons.profile.diagnostic.hint,
          },
        },
      })

      vim.lsp.config("*", { capabilities = capabilities })
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            check = { command = "clippy" },
          },
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "lua_ls", "pyright", "rust_analyzer" },
        automatic_enable = true,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
        callback = function(args)
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
          end
          map("gD", vim.lsp.buf.declaration, "LSP declaration")
          map("gd", vim.lsp.buf.definition, "LSP definition")
          map("gh", vim.lsp.buf.hover, "LSP hover")
          map("gi", vim.lsp.buf.implementation, "LSP implementation")
          map("<F2>", vim.lsp.buf.rename, "LSP rename")
          map("<leader>la", vim.lsp.buf.code_action, "Code action")
          map("<leader>lf", function()
            vim.lsp.buf.format({ async = true })
          end, "Format")
          map("<leader>lj", function()
            vim.diagnostic.jump({ count = 1, float = true })
          end, "Next diagnostic")
          map("<leader>lk", function()
            vim.diagnostic.jump({ count = -1, float = true })
          end, "Previous diagnostic")
          map("gl", vim.diagnostic.open_float, "Line diagnostics")
          map("<leader>lq", vim.diagnostic.setloclist, "Diagnostic list")
        end,
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      local null_ls = require("null-ls")
      local sources = {}
      local function add_if(executable, builtin)
        if vim.fn.executable(executable) == 1 then
          table.insert(sources, builtin)
        end
      end
      add_if("prettier", null_ls.builtins.formatting.prettier)
      add_if("black", null_ls.builtins.formatting.black)
      add_if("stylua", null_ls.builtins.formatting.stylua)
      add_if("yapf", null_ls.builtins.formatting.yapf)
      return {
        debug = false,
        sources = sources,
      }
    end,
  },
}

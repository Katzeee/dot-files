local icons = require("core.icons")

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<Tab>ca", function() vim.lsp.buf.code_action() end, desc = "Quick fix" },
    { "<Tab>cr", function() vim.lsp.buf.rename() end, desc = "Rename symbol" },
    { "<Tab>s", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
    { "<Tab>S", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
  },
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
      update_in_insert = true,
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
          diagnostics = { enable = true },
          inlayHints = {
            lifetimeElisionHints = { enable = "always" },
            bindingModeHints = { enable = true },
          },
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
        map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>U", vim.lsp.buf.references, "LSP references")
        map("<leader>u", "<cmd>Telescope lsp_references<cr>", "Search LSP references")
        map("<leader>in", vim.lsp.buf.incoming_calls, "Incoming calls")
        map("<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, "Format")
        map("<leader>ej", function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, "Next diagnostic")
        map("<leader>ek", function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, "Previous diagnostic")
        map("gl", vim.diagnostic.open_float, "Line diagnostics")

        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_group = vim.api.nvim_create_augroup("lsp_document_highlight_" .. args.buf, { clear = true })
          vim.api.nvim_create_autocmd("CursorHold", {
            group = highlight_group,
            buffer = args.buf,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd("CursorMoved", {
            group = highlight_group,
            buffer = args.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })
  end,
}

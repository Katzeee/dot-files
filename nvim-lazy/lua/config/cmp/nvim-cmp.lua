local M = {
  requires = {
    "cmp",
    "luasnip"
  }
}

require("luasnip/loaders/from_vscode").lazy_load()

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

--   פּ ﯟ   some other good icons
local kind_icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet


function M.before()
end

function M.load()
  M.cmp.setup {
    snippet = {
      expand = function(args)
        M.luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    mapping = {
          ["<C-j>"] = M.cmp.mapping(M.cmp.mapping.select_next_item({ behavior = M.cmp.SelectBehavior.Select }), { "i",
        "c", "s" }),
          ["<C-k>"] = M.cmp.mapping(M.cmp.mapping.select_prev_item({ behavior = M.cmp.SelectBehavior.Select }), { "i",
        "c", "s" }),
          ["<C-b>"] = M.cmp.mapping(M.cmp.mapping.scroll_docs(-1), { "i", "c" }),
          ["<C-f>"] = M.cmp.mapping(M.cmp.mapping.scroll_docs(1), { "i", "c" }),
          ["<A-x>"] = M.cmp.mapping(M.cmp.mapping.complete(), { "i", "c" }),
          ["<C-y>"] = M.cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
          ["<C-e>"] = M.cmp.mapping {
        i = M.cmp.mapping.abort(),
        c = M.cmp.mapping.close(),
      },
      -- Accept currently selected item. If none selected, `select` first item.
      -- Set `select` to `false` to only confirm explicitly selected items.
      -- ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<Tab>"] = M.cmp.mapping(function(fallback)
        if M.cmp.visible() then
          M.cmp.confirm()
        elseif M.luasnip.expandable() then
          M.luasnip.expand()
          -- elseif luasnip.expand_or_jumpable() then
          --   luasnip.expand_or_jump()
        elseif check_backspace() then
          fallback()
        else
          fallback()
        end
      end, { "i", "s", "c" }),
      -- ["<S-Tab>"] = cmp.mapping(function(fallback)
      --   if cmp.visible() then
      --     cmp.select_prev_item()
      --   elseif luasnip.jumpable( -1) then
      --     luasnip.jump( -1)
      --   else
      --     fallback()
      --   end
      -- end, {
      --     "i",
      --     "s",
      -- }),
    },
    completion = {
      -- preselect the first selection
      completeopt = 'menu, menuone, noinsert'
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        -- Kind icons
        vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
        -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
        vim_item.menu = ({
              nvim_lsp = "[LSP]",
              -- nvim_lua = "[NVIM_LUA]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
        return vim_item
      end,
    },
    sources = {
      { name = "nvim_lsp" },
      -- { name = "nvim_lua" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
    },
    confirm_opts = {
      behavior = M.cmp.ConfirmBehavior.Replace,
      select = false,
    },
    view = { entry = "wildmenu" },
    -- experimental = {
    --   ghost_text = false,
    --   native_menu = false,
    -- },
  }
end

function M.after()
  M.cmp.setup.cmdline(":", {
    sources = {
      { name = 'cmdline' },
      { name = "path" },
    },
    completion = {
      autocomplete = {
        M.cmp.TriggerEvent.TextChanged,
      }
    }
  })

  M.cmp.setup.cmdline({ '/', '?' }, {
    sources = {
      { name = 'buffer' }
    }
  })
end

return M

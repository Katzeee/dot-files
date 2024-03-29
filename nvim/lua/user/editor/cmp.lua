local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

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

cmp.setup.cmdline(":", {
    sources = {
        { name = 'cmdline' },
        { name = "path" },
    },
    completion = {
        autocomplete = {
            cmp.TriggerEvent.TextChanged,
        }
    }
})

cmp.setup.cmdline('/', {
    -- completion = { autocomplete =  },
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup {
    snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = {
        -- ["<C-j>"] = cmp.mapping({
        --     i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        --     c = function(fallback)
        --       if cmp.visible() then
        --         return cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select })
        --       end
        --       fallback()
        --     end
        -- }),
        -- ["<C-k>"] = cmp.mapping({
        --     i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        --     c = function(fallback)
        --       if cmp.visible() then
        --         return cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        --       end
        --       fallback()
        --     end
        -- }),
        ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c", "s" }),
        ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c", "s" }),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs( -1), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
        ["<A-x>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ["<C-e>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        },
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        -- ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm()
          elseif luasnip.expandable() then
            luasnip.expand()
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
        -- highlight the first selection
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
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
    },
    views = { entry = "wildmenu" },
    -- window = {
    --   documentation = cmp.config.window.bordered()
    -- },
    experimental = {
        ghost_text = false,
        native_menu = false,
    },
}

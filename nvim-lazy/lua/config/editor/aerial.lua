local M = {
  requires = {
    "aerial",
  },
}
function M.before()
end

function M.register_key()
end

function M.load()
  M.aerial.setup({
    -- icons = icons,
    show_guides = true,
    backends = { "lsp", "treesitter", "markdown" },
    update_events = "TextChanged,InsertLeave",
    ---@diagnostic disable-next-line: unused-local
    on_attach = function(bufnr)
      M.register_key()
    end,
    layout = {
      min_width = 30,
      max_width = { 40, 0.2 },
    },
    lsp = {
      diagnostics_trigger_update = false,
      update_when_errors = true,
      update_delay = 300,
    },
    guides = {
      mid_item = "├─",
      last_item = "└─",
      nested_top = "│ ",
      whitespace = "  ",
    },
    filter_kind = {
      "Module",
      "Struct",
      "Interface",
      "Class",
      "Constructor",
      "Enum",
      "Function",
      "Method",
    },
  })
end

function M.after()
end

return M

return {
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
}

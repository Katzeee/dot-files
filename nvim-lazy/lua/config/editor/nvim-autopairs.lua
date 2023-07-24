-- Setup nvim-cmp.
local M = {
  requires = {
    "nvim-autopairs",
  },
}

function M.before() end

function M.load()
  M.nvim_autopairs.setup({
    check_ts = true,
    ts_config = {
      lua = { "string" }, -- it will not add a pair on that treesitter node
      javascript = { "template_string" },
      java = false,    -- don't check treesitter on java
    },
    disable_filetype = { "TelescopePrompt", "spectre_panel" },
    -- fast_wrap = {
    --   map = "gs",
    --   chars = { "{", "[", "(", '"', "'" },
    --   pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
    --   offset = 0, -- Offset from pattern match
    --   end_key = "$",
    --   keys = "qwertyuiopzxcvbnmasdfghjkl",
    --   check_comma = true,
    --   highlight = "PmenuSel",
    --   highlight_grey = "LineNr",
    -- },
  })
end

function M.after() end

-- local cmp_autopairs = require "nvim-autopairs.completion.cmp"
-- local cmp_status_ok, cmp = pcall(require, "cmp")
-- if not cmp_status_ok then
-- return
-- end
-- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })

return M

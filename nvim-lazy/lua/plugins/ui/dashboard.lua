return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  opts = function()
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      " _   _                 _",
      "| \\ | | ___  _____   _(_)_ __ ___",
      "|  \\| |/ _ \\/ _ \\ \\ / / | '_ ` _ \\",
      "| |\\  |  __/ (_) \\ V /| | | | | | |",
      "|_| \\_|\\___|\\___/ \\_/ |_|_| |_| |_|",
    }
    dashboard.section.buttons.val = {
      dashboard.button("f", "Find file", "<cmd>Telescope find_files<cr>"),
      dashboard.button("n", "New file", "<cmd>ene | startinsert<cr>"),
      dashboard.button("r", "Recent files", "<cmd>Telescope oldfiles<cr>"),
      dashboard.button("g", "Find text", "<cmd>Telescope live_grep<cr>"),
      dashboard.button("c", "Edit config", "<cmd>edit $MYVIMRC<cr>"),
      dashboard.button("l", "Plugin manager", "<cmd>Lazy<cr>"),
      dashboard.button("q", "Quit", "<cmd>quitall<cr>"),
    }
    dashboard.section.footer.val = "Neovim"

    return dashboard.config
  end,
  config = function(_, opts)
    local alpha = require("alpha")
    alpha.setup(opts)
    -- This spec itself is loaded on VimEnter, so Alpha's own VimEnter
    -- autocommand would otherwise be registered one event too late.
    alpha.start(true, opts)
  end,
}

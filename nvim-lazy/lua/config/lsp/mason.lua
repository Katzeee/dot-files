local M = {
  requires = {
    "mason"
  }
}

function M.before() end

function M.load()
  M.mason.setup {
    ui = {
      border = "none",
      icons = {
                package_installed = "",
                package_pending = "",
                package_uninstalled = "",
      },
    },
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,
  }

end

function M.after()
end

return M

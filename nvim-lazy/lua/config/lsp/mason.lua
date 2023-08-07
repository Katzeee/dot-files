local M = {
  requires = {
    "mason",
    "mason-registry" -- api in mason
  }
}

function M.before()
  M.mason_packages = {
    lsp = {
      "clangd",
      "lua-language-server",
      "pyright"
    }
  }
end

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
  local installed_packages = {}
  for _, package_kind in pairs(M.mason_packages) do
    for _, package_name_version in pairs(package_kind) do
      ---@diagnostic disable-next-line: missing-parameter
      local name, version = unpack(vim.split(package_name_version, "@"))

      if not M.mason_registry.is_installed(name) then
        if not M.mason_registry.has_package(name) then
          vim.notify(("Invalid package name : %s"):format(name), "ERROR", { title = "Mason" })
        else
          local params = version and { version = version }
          M.mason_registry.get_package(name):install(params)
          table.insert(installed_packages, package_name_version)
        end
      end
    end
  end

  if not vim.tbl_isempty(installed_packages) then
    vim.notify(
      ("Start install package : \n - %s"):format(table.concat(installed_packages, "\n - ")),
      "INFO",
      { title = "Mason" }
    )
  end
end

return M

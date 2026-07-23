local M = {}

local pending = {}

local function finish(name, success, err)
  local callbacks = pending[name] or {}
  pending[name] = nil

  for _, callback in ipairs(callbacks) do
    vim.schedule(function()
      callback(success, err)
    end)
  end
end

---Ensure that a command-line tool managed by Mason is installed.
---@param name string Mason registry package name
---@param callback fun(success: boolean, err?: any)
function M.ensure(name, callback)
  if pending[name] then
    table.insert(pending[name], callback)
    return
  end

  pending[name] = { callback }

  require("mason-registry").refresh(function(success)
    if not success then
      finish(name, false, "Mason registry refresh failed")
      return
    end

    local registry = require("mason-registry")
    if not registry.has_package(name) then
      finish(name, false, ("Mason package is unavailable: %s"):format(name))
      return
    end

    local package = registry.get_package(name)
    if package:is_installed() then
      finish(name, true)
      return
    end

    if package:is_installing() then
      package:get_install_handle():if_present(function(handle)
        handle:once("closed", function()
          finish(name, package:is_installed(), "Mason installation failed")
        end)
      end)
      return
    end

    package:install({}, function(installed, result)
      finish(name, installed, installed and nil or result)
    end)
  end)
end

return M

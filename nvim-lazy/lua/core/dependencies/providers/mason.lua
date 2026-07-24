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

local function ensure(options, callback)
  local name = options.package
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
    local try_install

    local function retry_or_finish(attempt, err)
      if attempt >= options.attempts then
        finish(name, false, err or "Mason installation failed")
        return
      end

      vim.defer_fn(function()
        try_install(attempt + 1)
      end, options.retry_delay_ms)
    end

    try_install = function(attempt)
      if package:is_installed() then
        finish(name, true)
        return
      end

      if package:is_installing() then
        package:get_install_handle():if_present(function(handle)
          handle:once("closed", function()
            if package:is_installed() then
              finish(name, true)
            else
              retry_or_finish(attempt, "Mason installation failed")
            end
          end)
        end)
        return
      end

      package:install({ force = attempt > 1 }, function(installed, result)
        if installed then
          finish(name, true)
        else
          retry_or_finish(attempt, result)
        end
      end)
    end

    try_install(1)
  end)
end

---Create an external dependency provided by a Mason package.
---@param options { package: string, id?: string, attempts?: integer, retry_delay_ms?: integer }
---@return { id: string, ensure: fun(callback: fun(success: boolean, err?: any)) }
function M.package(options)
  assert(type(options) == "table", "Mason dependency options must be a table")
  assert(type(options.package) == "string" and options.package ~= "", "options.package must be a non-empty string")

  local attempts = options.attempts or 1
  local retry_delay_ms = options.retry_delay_ms or 0
  assert(type(attempts) == "number" and attempts >= 1 and attempts % 1 == 0, "options.attempts must be an integer")
  assert(type(retry_delay_ms) == "number" and retry_delay_ms >= 0, "options.retry_delay_ms must be non-negative")

  local resolved = {
    package = options.package,
    attempts = attempts,
    retry_delay_ms = retry_delay_ms,
  }

  return {
    id = options.id or options.package,
    ensure = function(callback)
      ensure(resolved, callback)
    end,
  }
end

return M

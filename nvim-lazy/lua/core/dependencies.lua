local M = {}

local registrations = {}
local loaded = {}
local states = {}
local setup_done = false

local function notify(message, level)
  vim.schedule(function()
    vim.notify(message, level or vim.log.levels.ERROR, { title = "External dependencies" })
  end)
end

local function activate(plugin)
  local registration = registrations[plugin]
  if not registration or states[plugin] == "ensuring" or states[plugin] == "ready" then
    return
  end

  states[plugin] = "ensuring"
  local remaining = #registration.requires
  local errors = {}

  local function complete()
    if #errors > 0 then
      states[plugin] = "failed"
      notify(("Unable to prepare dependencies for %s:\n%s"):format(plugin, table.concat(errors, "\n")))
      return
    end

    states[plugin] = "ready"
    if registration.on_ready then
      local ok, err = pcall(registration.on_ready)
      if not ok then
        notify(("Dependency-ready action failed for %s: %s"):format(plugin, err))
      end
    end
  end

  if remaining == 0 then
    complete()
    return
  end

  for _, dependency in ipairs(registration.requires) do
    local current = dependency
    local called = false
    local function done(success, err)
      if called then
        return
      end
      called = true

      if not success then
        errors[#errors + 1] = ("%s: %s"):format(current.id, err or "unknown error")
      end
      remaining = remaining - 1
      if remaining == 0 then
        complete()
      end
    end

    local ok, err = pcall(current.ensure, done)
    if not ok then
      done(false, err)
    end
  end
end

---Register external dependencies that a Lazy plugin does not provide itself.
---@param plugin string Lazy plugin name
---@param registration { requires: { id: string, ensure: fun(callback: fun(success: boolean, err?: any)) }[], on_ready: function? }
function M.register(plugin, registration)
  assert(type(plugin) == "string" and plugin ~= "", "plugin must be a non-empty string")
  assert(type(registration) == "table", "registration must be a table")
  assert(type(registration.requires) == "table", "registration.requires must be a table")
  assert(registrations[plugin] == nil, ("dependencies already registered for %s"):format(plugin))

  for _, dependency in ipairs(registration.requires) do
    assert(type(dependency) == "table", "dependencies must be tables")
    assert(type(dependency.id) == "string" and dependency.id ~= "", "dependency.id must be a non-empty string")
    assert(type(dependency.ensure) == "function", "dependency.ensure must be a function")
  end

  registrations[plugin] = registration
  if loaded[plugin] then
    activate(plugin)
  end
end

function M.setup()
  if setup_done then
    return
  end
  setup_done = true

  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("external_plugin_dependencies", { clear = true }),
    pattern = "LazyLoad",
    callback = function(args)
      local plugin = args.data
      if type(plugin) ~= "string" then
        return
      end
      loaded[plugin] = true
      activate(plugin)
    end,
  })
end

return M

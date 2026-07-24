local M = {}

local warned = {}

local function notify_once(key, message)
  if warned[key] then
    return
  end
  warned[key] = true
  vim.schedule(function()
    vim.notify(message, vim.log.levels.WARN, { title = "Project command" })
  end)
end

local function valid(command)
  if type(command) ~= "table" or #command == 0 then
    return false
  end
  for _, argument in ipairs(command) do
    if type(argument) ~= "string" then
      return false
    end
  end
  return true
end

local function is_absolute(path)
  return path:match("^/") ~= nil or path:match("^%a:[/\\]") ~= nil or path:match("^\\\\") ~= nil
end

---Get a configured command for the current project.
---@param name string
---@return string[]? command
---@return string root
function M.get(name)
  local config = require("core.project.config").get()
  local commands = config.values.commands
  local command = type(commands) == "table" and commands[name] or nil

  if command == nil then
    return nil, config.root
  end
  if not valid(command) then
    notify_once(
      config.root .. ":" .. name .. ":invalid",
      ("Ignoring invalid command %q in project configuration"):format(name)
    )
    return nil, config.root
  end

  command = vim.deepcopy(command)
  if not is_absolute(command[1]) and command[1]:find("[/\\]") then
    command[1] = vim.fs.joinpath(config.root, command[1])
  end

  if vim.fn.executable(command[1]) ~= 1 then
    notify_once(
      config.root .. ":" .. name .. ":missing",
      ("Command for %s is not executable: %s; using fallback"):format(name, command[1])
    )
    return nil, config.root
  end

  return command, config.root
end

return M

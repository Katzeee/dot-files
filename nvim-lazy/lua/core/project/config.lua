local M = {}

local warned = {}

local function notify_once(key, message, level)
  if warned[key] then
    return
  end
  warned[key] = true
  vim.schedule(function()
    vim.notify(message, level or vim.log.levels.WARN, { title = "Project config" })
  end)
end

local function normalize(path)
  path = vim.fs.normalize(path):gsub("\\", "/"):gsub("/+$", "")
  return vim.fn.has("win32") == 1 and path:lower() or path
end

local function contains(parent, child)
  return child == parent or child:sub(1, #parent + 1) == parent .. "/"
end

local function read_json(path)
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    notify_once(path, ("Unable to read %s"):format(path), vim.log.levels.ERROR)
    return nil
  end

  local decoded_ok, value = pcall(vim.json.decode, table.concat(lines, "\n"))
  if not decoded_ok or type(value) ~= "table" then
    notify_once(path, ("Invalid JSON in %s"):format(path), vim.log.levels.ERROR)
    return nil
  end
  return value
end

local function context_path()
  local name = vim.api.nvim_buf_get_name(0)
  if name ~= "" and vim.bo.buftype == "" then
    return vim.fs.dirname(vim.fs.normalize(name))
  end
  return vim.fs.normalize(vim.fn.getcwd())
end

local function find_project_file(start)
  return vim.fs.find(".nvim/config.json", {
    path = start,
    upward = true,
    type = "file",
  })[1]
end

local function home_projects()
  local path = vim.fs.normalize(vim.fn.expand("~/.nvim/config.json"))
  if not vim.uv.fs_stat(path) then
    return {}
  end

  local config = read_json(path)
  return config and type(config.projects) == "table" and config.projects or {}
end

local function matching_home_project(projects, path)
  local normalized_path = normalize(path)
  local best_root
  local best

  for root, value in pairs(projects) do
    if type(root) == "string" and type(value) == "table" then
      local normalized_root = normalize(vim.fn.expand(root))
      if contains(normalized_root, normalized_path) and (not best_root or #normalized_root > #best_root) then
        best_root = normalized_root
        best = value
      end
    end
  end

  return best_root, best
end

---Resolve the configuration for the current buffer or working directory.
---@return { root: string, values: table }
function M.get()
  local start = context_path()
  local project_file = find_project_file(start)
  local project_root = project_file and vim.fs.dirname(vim.fs.dirname(project_file)) or nil
  local home_root, home_project = matching_home_project(home_projects(), project_root or start)

  project_root = project_root or home_root or start
  local values = {}

  if project_file then
    if home_project and home_project.trust_level == "trusted" then
      values = read_json(project_file) or {}
    else
      notify_once(
        project_file .. ":untrusted",
        ("Ignoring untrusted project config: %s\nAdd trust_level \"trusted\" under this project in ~/.nvim/config.json")
          :format(project_file)
      )
    end
  end

  -- Preserve the existing precedence: settings explicitly stored in the
  -- user's home configuration override repository-local values.
  if home_project then
    values = vim.tbl_deep_extend("force", values, home_project)
  end

  return {
    root = vim.fs.normalize(project_root),
    values = values,
  }
end

return M

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

local function context_paths()
  local paths = {}
  local name = vim.api.nvim_buf_get_name(0)
  if name ~= "" and vim.bo.buftype == "" then
    paths[#paths + 1] = vim.fs.dirname(vim.fs.normalize(name))
  end

  local cwd = vim.fs.normalize(vim.fn.getcwd())
  if #paths == 0 or normalize(paths[1]) ~= normalize(cwd) then
    paths[#paths + 1] = cwd
  end
  return paths
end

local function home_config_path()
  return vim.fs.normalize(vim.fn.expand("~/.nvim/config.json"))
end

local function find_project_file(start)
  local path = vim.fs.find(".nvim/config.json", {
    path = start,
    upward = true,
    type = "file",
  })[1]
  if path and normalize(path) == normalize(home_config_path()) then
    return nil
  end
  return path
end

local function home_projects()
  local path = home_config_path()
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

local function resolve(start, projects)
  local project_file = find_project_file(start)
  local project_root = project_file and vim.fs.dirname(vim.fs.dirname(project_file)) or nil
  local home_root, home_project = matching_home_project(projects, project_root or start)

  if not project_file and not home_project then
    return nil
  end

  local values = project_file and (read_json(project_file) or {}) or {}
  if home_project then
    values = vim.tbl_deep_extend("force", values, home_project)
  end

  return {
    root = vim.fs.normalize(project_root or home_root),
    values = values,
  }
end

---Resolve the configuration for the current buffer or working directory.
---@return { root: string, values: table }
function M.get()
  local starts = context_paths()
  local projects = home_projects()
  for _, start in ipairs(starts) do
    local config = resolve(start, projects)
    if config then
      return config
    end
  end

  return {
    root = starts[1],
    values = {},
  }
end

return M

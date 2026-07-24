local M = {}

local function project_command(name)
  return require("core.project.command").get(name)
end

function M.find_files()
  local builtin = require("telescope.builtin")
  local command, root = project_command("find_files")

  builtin.find_files({
    cwd = root,
    find_command = command,
    theme = "dropdown",
    previewer = false,
  })
end

local function symbol_entry(root)
  local warned = false

  return function(line)
    local ok, symbol = pcall(vim.json.decode, line)
    if not ok or type(symbol) ~= "table" or type(symbol.name) ~= "string" or type(symbol.path) ~= "string" then
      if not warned then
        warned = true
        vim.schedule(function()
          vim.notify(
            "find_workspace_symbols must output one JSON object per line with name and path",
            vim.log.levels.ERROR,
            { title = "Project search" }
          )
        end)
      end
      return nil
    end

    local path = symbol.path
    if not path:match("^/") and not path:match("^%a:[/\\]") and not path:match("^\\\\") then
      path = vim.fs.joinpath(root, path)
    end

    local line_number = tonumber(symbol.line) or 1
    local column = tonumber(symbol.column) or 1
    local kind = symbol.kind and (" [" .. tostring(symbol.kind) .. "]") or ""
    local relative = vim.fs.relpath(root, path) or path

    return {
      value = symbol,
      ordinal = table.concat({ symbol.name, tostring(symbol.kind or ""), relative }, " "),
      display = ("%s%s  %s:%d"):format(symbol.name, kind, relative, line_number),
      filename = path,
      lnum = line_number,
      col = column,
    }
  end
end

function M.find_workspace_symbols()
  local command, root = project_command("find_workspace_symbols")
  if not command then
    require("telescope.builtin").lsp_workspace_symbols()
    return
  end

  local finders = require("telescope.finders")
  local pickers = require("telescope.pickers")
  local conf = require("telescope.config").values

  pickers
    .new({}, {
      prompt_title = "Workspace Symbols",
      cwd = root,
      finder = finders.new_job(function(prompt)
        if prompt == "" then
          return nil
        end
        local invocation = vim.deepcopy(command)
        invocation[#invocation + 1] = prompt
        return invocation
      end, symbol_entry(root), nil, root),
      previewer = conf.grep_previewer({}),
      sorter = conf.generic_sorter({}),
    })
    :find()
end

return M

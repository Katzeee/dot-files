local utils = require "utils"

local M = {
  -- plugin config file root directory
  plugin_config_root_directory = "config",
}

local install_path = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

function M.get_opts()
  return {
    -- plugin install root directory
    -- root = install_path,
    install = {
      colorscheme = { "default" },
    },
    ui = {
      border = "none" -- or "double",
    },
  }
end

local function require_all_package(module)
  if not module.requires then
    return
  end

  local replace_char = {
    ["%."] = "_",
    ["%-"] = "_",
  }

  for _, require_name in ipairs(module.requires) do
    local use_name = require_name

    for char, replace in pairs(replace_char) do
      if use_name:match(char) then
        use_name = (use_name:gsub(char, replace)):lower()
      end
    end

    module[use_name:lower()] = require(require_name)
  end
end

function M.before()
  if not vim.loop.fs_stat(install_path) then
    vim.notify("Download lazy.nvim ...", vim.log.levels.INFO, { title = "Lazy" })
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      install_path,
    })
  end
  vim.opt.runtimepath:prepend(install_path)
  M.lazy = require("lazy")
end

function M.load(plugins)
  local requires_moduls = {}

  for plugin_kind_name, plugin_kind_tbl in pairs(plugins) do
    for _, plugin_opts in ipairs(plugin_kind_tbl) do
      if not plugin_opts.dir then
        local require_file_name = (plugin_opts.name or plugin_opts[1]:match("/([%w%-_]+).?")):lower()

        local require_file_path = utils.path.join(M.plugin_config_root_directory, plugin_kind_name, require_file_name)

        local ok, module = pcall(require, require_file_path)

        if ok then
          -- print(require_file_path, module)
          plugin_opts.init = plugin_opts.init
              or function()
                module.before()
              end

          plugin_opts.config = plugin_opts.config
              or function()
                require_all_package(module)
                module.load()
                module.after()
              end
        end
      end
      table.insert(requires_moduls, plugin_opts)
    end
  end

  M.lazy.setup(requires_moduls, M.get_opts())
end

function M.after()
  M.register_key()
end

function M.entry(plugins)
  M.before()
  M.load(plugins)
  M.after()
end

function M.register_key()
end

return M

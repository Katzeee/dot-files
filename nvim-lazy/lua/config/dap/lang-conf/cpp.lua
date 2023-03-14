local M = {}

-- local dap_install = require("dap-install")
-- dap_install.config("codelldb", {})

-- local dap = require("dap")
local install_root_dir = vim.fn.stdpath("data") .. "/mason"
local extension_path = install_root_dir .. "/packages/codelldb/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"

-- dap.configurations.cpp = {}

-- dap.configurations.c = dap.configurations.cpp
-- dap.configurations.rust = dap.configurations.cpp

return {
	adapters = {
		lldb = {
			type = "executable",
			command = "/usr/bin/lldb-vscode",
			name = "lldb",
		},
		codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = codelldb_path,
				-- args = { "--params", '{"showDisassembly" : "never"}', "--port", "${port}" },
				args = { "--port", "${port}" },
				-- https://github.com/mfussenegger/nvim-dap/issues/307
				-- On windows you may have to uncomment this:
				-- detached = false,
			},
			-- showDisassembly = "always"
		},
		cppdbg = {
			id = "cppdbg",
			type = "executable",
			command = install_root_dir .. "/bin/OpenDebugAD7",
		},
	},
	configurations = {
		cpp = {
			{
				name = "Launch (codelldb)",
				type = "codelldb",
				-- type = "cppdbg",
				-- type = "lldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
        -- runInTerminal = true,
        -- terminal = "integrated",
				-- initCommands = { "target stop-hook add -n _start -o continue" },
			},
		},
	},
}

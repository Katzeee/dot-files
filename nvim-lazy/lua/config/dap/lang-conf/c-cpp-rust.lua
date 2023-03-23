---@diagnostic disable: param-type-mismatch
local M = {}

local install_root_dir = vim.fn.stdpath("data") .. "/mason"
local extension_path = install_root_dir .. "/packages/codelldb/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"

M = {
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
				name = "Launch file(cppdbg)",
				type = "cppdbg",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = { "-q" },
				setupCommands = {
					{
						text = "-enable-pretty-printing",
						description = "enable pretty printing",
						ignoreFailures = false,
					},
				},
			},
			{
				name = "Attach process(cppdbg)",
				type = "cppdbg",
				request = "attach",
				processId = require("dap.utils").pick_process,
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				args = { "-q" },
				setupCommands = {
					{
						text = "-enable-pretty-printing",
						description = "enable pretty printing",
						ignoreFailures = false,
					},
				},
			},
			{
				name = "Attach to gdbserver(cppdbg)",
				type = "cppdbg",
				request = "launch",
				miDebuggerServerAddress = "localhost:1234",
				miDebuggerPath = "/bin/gdb",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				args = { "-q" },
				setupCommands = {
					{
						text = "-enable-pretty-printing",
						description = "enable pretty printing",
						ignoreFailures = false,
					},
				},
			},
		},
	},
}

M.configurations.rust = M.configurations.cpp

return M

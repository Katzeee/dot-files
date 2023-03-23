local dap_servers = require("lang-spec-conf").dap
local utils = require("utils")

local M = {
	requires = {
		"dap",
	},
	adapter_configurations_dir_path = utils.path.join_with_point("config", "dap", "lang-conf"),
}

function M.before()
	M.register_key()
	vim.keymap.set("n", "<Leader>ds", function()
		local widgets = require("dap.ui.widgets")
		widgets.centered_float(widgets.threads)
	end)
end

function M.load()
	-- print(vim.inspect(M.dap))
	-- M.dap.defaults.fallback.auto_continue_if_many_stopped = true

	---@diagnostic disable-next-line: param-type-mismatch
	for _, dap_server in ipairs(dap_servers) do
		local dap_conf_file = utils.path.join_with_point(M.adapter_configurations_dir_path, dap_server)
		local require_ok, conf_opts = pcall(require, dap_conf_file)
		if require_ok then
			M.dap.adapters = vim.tbl_deep_extend("force", M.dap.adapters, conf_opts.adapters or {})
			-- print(vim.inspect(M.dap.adapters))
			M.dap.configurations = vim.tbl_deep_extend("force", M.dap.configurations, conf_opts.configurations or {})
			-- print(vim.inspect(M.dap.configurations))
		end
	end
	-- M.dap.listeners.before.event_initialized["split_window"] = function()
	--   vim.cmd("vs")
	-- end
end

function M.after()
	require("dap.ext.vscode").load_launchjs(nil, { cppdbg = { "c", "cpp", "rust" } })
end

function M.register_key()
	utils.keymap.batch_register_in_mode({ "n" }, {
		{
			lhs = "<leader>b",
			rhs = function()
				require("dap").toggle_breakpoint()
			end,
			options = { silent = true },
			description = "Mark or delete breakpoints",
		},
		{
			lhs = "<leader>dc",
			rhs = function()
				require("dap").clear_breakpoints()
			end,
			options = { silent = true },
			description = "Clear breakpoints in the current buffer",
		},
		{
			lhs = "<F5>",
			rhs = function()
				require("dap").continue()
			end,
			options = { silent = true },
			description = "Enable debugging or jump to the next breakpoint",
		},
		{
			lhs = "<F6>",
			rhs = function()
				require("dap").step_into()
			end,
			options = { silent = true },
			description = "Step into",
		},
		{
			lhs = "<F7>",
			rhs = function()
				---@diagnostic disable-next-line: missing-parameter
				require("dap").step_over()
			end,
			options = { silent = true },
			description = "Step over",
		},
		{
			lhs = "<F8>",
			rhs = function()
				require("dap").step_out()
			end,
			options = { silent = true },
			description = "Step out",
		},
		{
			lhs = "<F9>",
			rhs = function()
				require("dap").run_last()
			end,
			options = { silent = true },
			description = "Rerun debug",
		},
		{
			lhs = "<F10>",
			rhs = function()
				require("dap").terminate()
			end,
			options = { silent = true },
			description = "Close debug",
		},
	})
end

return M

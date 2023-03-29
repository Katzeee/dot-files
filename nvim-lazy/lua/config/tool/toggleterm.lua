local utils = require("utils")
local M = {
	requires = {
		"toggleterm",
		"toggleterm.terminal",
		"code_runner",
	},
}

M.terminals = {}

function M.before() end

function M.load()
	M.Terminal = M.toggleterm_terminal.Terminal
	M.toggleterm.setup({
		shade_terminals = true,
		shading_factor = 1,
		highlights = {
			NormalFloat = {
				link = "NormalFloat",
			},
			FloatBorder = {
				link = "FloatBorder",
			},
		},
	})
	M.code_runner.setup({
		mode = "toggleterm",
		filetype = {
			cpp = "cd $dir",
		},
	})
end

function M.after()
	M.create_terminal()
	M.wrapper_commands()
end

function M.unregister_esc()
	utils.keymap.unregister({ "t" }, "<esc>")
end

function M.create_terminal()
	M.terminals.float = M.Terminal:new({
		hidden = true,
		count = 5,
		direction = "float",
		float_opts = {
			border = "double",
		},
		on_open = function(term)
			utils.keymap.batch_register_in_mode({ "t" }, {
				{
					lhs = "<esc>",
					rhs = "<C-\\><C-n><cmd>close<CR>",
					options = { silent = true, noremap = true, buffer = term.bufnr },
					desc = "Esc to exit float term",
				},
			})
		end,
		-- on_close = M.unregister_esc,
	})
	M.terminals.lazygit = M.Terminal:new({
		cmd = "lazygit",
		-- dir = "git_dir",
		hidden = true,
		direction = "float",
		float_opts = {
			border = "single",
		},
		on_hidden = function()
			vim.api.nvim_cmd({"bufdo! e"})
		end,
	})
end

function M.wrapper_commands()
	M.toggleterm.lazygit_toggle = function()
		M.terminals.lazygit:toggle()
	end
	M.toggleterm.float_toggle = function()
		M.terminals.float:toggle()
	end
end

return M

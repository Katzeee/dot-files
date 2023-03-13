local M = {
	requires = {
		"indent_blankline",
	},
}

function M.before() end

function M.load()
	M.indent_blankline.setup({
		-- space_char_blankline = " ",
		show_current_context = true,
    show_end_of_line = true,
		show_current_context_start = true,
	})
end

function M.after() end

return M

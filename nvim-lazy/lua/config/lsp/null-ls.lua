local M = {
	requires = {
		"null-ls"
	}
}


function M.before()
end

function M.load()
	local formatting = M.null_ls.builtins.formatting
	local diagnostics = M.null_ls.builtins.diagnostics
	M.null_ls.setup({
		debug = false,
		sources = {
			formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
			formatting.black.with({ extra_args = { "--fast" } }),
			formatting.stylua,
			-- diagnostics.flake8
		},
	})
end

function M.after()
end

return M

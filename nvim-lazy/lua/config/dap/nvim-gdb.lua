local M = {
	requires = {
		-- "nvim-gdb",
	},
}

function M.load()
	vim.cmd([[
    let g:nvimgdb_disable_start_keymaps = 1
    let g:nvimgdb_use_find_executables = 0
    let g:nvimgdb_use_cmake_to_find_executables = 0
    let w:nvimgdb_termwin_command = "rightbelow vnew"
    let w:nvimgdb_codewin_command = "vnew"
    let g:nvimgdb_config_override = {
      \ 'key_next': '-n',
      \ 'key_step': '-s',
      \ 'key_finish': '-f',
      \ 'key_continue': '-c',
      \ 'key_until': '-u',
      \ 'key_breakpoint': '-b',
  \ }
]])

	vim.cmd([[
  nnoremap <silent> <expr> <leader>dd ":GdbStart gdb -q \<space>"
]])
	-- use :GdbStart gdb -q --args ./a.out arg1 arg2 ...

	vim.api.nvim_set_keymap("n", "<leader>b", ":GdbBreakpointToggle<CR>", { noremap = true, silent = true })

	_G.GdbSessionInit = function()
		vim.api.nvim_command(":NvimTreeClose")
	end

	_G.CreateWatch = function()
		local watch_arg = vim.fn.input("Watch cmd: ")
		vim.api.nvim_command(":GdbCreateWatch " .. watch_arg)
	end

	vim.cmd([[
  autocmd User NvimGdbStart :lua GdbSessionInit()
]])
end

function M.before() end

function M.after() end

return M

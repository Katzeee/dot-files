---@diagnostic disable: param-type-mismatch

local M = {
	path = {},
	keymap = {},
}

function M.path.join_with_slash(...)
	return table.concat(vim.tbl_flatten({ ... }), "/")
end

function M.path.join_with_point(...)
	return table.concat(vim.tbl_flatten({ ... }), ".")
end

function M.path.exists(p)
	return vim.fn.filereadable(p) == 1
end

function M.path.listdir(p)
	return vim.fn.globpath(p, "*", false, true)
end

function M.path.listdir_by_filetype(p, filetype)
	return vim.fn.globpath(p, ("*.%s"):format(filetype), false, true)
end

function M.keymap.register(map)
	map.options.desc = map.desc
	if type(map.rhs) == "function" or map.options.buffer then
		vim.keymap.set(map.mode, map.lhs, map.rhs, map.options)
		return
	end

	for _, mode in ipairs(map.mode) do
		vim.api.nvim_set_keymap(mode, map.lhs, map.rhs, map.options)
		return
	end
end

function M.keymap.unregister(mode, lhs, opts)
	vim.keymap.del(mode, lhs, opts)
end

function M.keymap.batch_register(maps)
	for _, map in pairs(maps) do
		M.keymap.register(map)
	end
end

function M.keymap.batch_register_in_mode(mode, maps)
	for _, map in pairs(maps) do
		map.mode = mode
		M.keymap.register(map)
	end
end

return M

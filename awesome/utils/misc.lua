local awful = require("awful")
local beautiful = require("beautiful")
local M = {}

-- http://lua-users.org/wiki/CopyTable
M.deepcopy = function(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[M.deepcopy(orig_key)] = M.deepcopy(orig_value)
		end
		setmetatable(copy, M.deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

M.range = function(from, to, step)
	local t = {}
	step = step or 1

	for i = from, to, step do
		t[#t + 1] = i
	end

	return t
end

M.tbl_override = function(t1, t2)
	local merged = M.deepcopy(t1)

	for k, v in pairs(t2) do
		if type(v) == "table" then
			merged[k] = M.tbl_override(merged[k], v)
		else
			merged[k] = v
		end
	end

	return merged
end

M.dump = function(o)
	if type(o) == "table" then
		local s = "{ "
		for k, v in pairs(o) do
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
			s = s .. "[" .. k .. "] = " .. M.dump(v) .. ","
		end
		return s .. "} "
	else
		return tostring(o)
	end
end

M.bind = function(f, args)
	return function()
		if args then
			return f(table.unpack(args))
		end
		return f()
	end
end

--check if table contains item
function M.contains(obj, value)
	for _, v in pairs(obj) do if v == value then return true end end
	return false
end

function M.prompt(action, textbox, prompt, callback)
	if action == "run" then
		awful.prompt.run({
			prompt = prompt,
			-- prompt       = "<b>Run: </b>",
			textbox = textbox,
			font = beautiful.font_name .. "Regular 12",
			done_callback = callback,
			exe_callback = awful.spawn,
			completion_callback = awful.completion.shell,
			history_path = awful.util.get_cache_dir() .. "/history",
		})
	elseif action == "web_search" then
		awful.prompt.run({
			prompt = prompt,
			-- prompt       = '<b>Web search: </b>',
			textbox = textbox,
			font = beautiful.font_name .. "Regular 12",
			history_path = awful.util.get_cache_dir() .. "/history_web",
			done_callback = callback,
			exe_callback = function(input)
				if not input or #input == 0 then
					return
				end
				awful.spawn.with_shell("noglob " .. "xdg-open https://www.google.com/search?q=" .. "'" .. input .. "'")
				-- naughty.notify({
				-- 	title = "Searching the web for",
				-- 	text = input,
				-- 	icon = gears.color.recolor_image(icons.web_browser, beautiful.accent),
				-- 	urgency = "low",
				-- })
			end,
		})
	end
end

return M

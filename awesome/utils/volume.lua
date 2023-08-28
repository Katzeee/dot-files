local awful = require("awful")
local naughty = require("naughty")

local M = {}

-- local widget = nil
local noti_obj = nil

local volume_set = "amixer -D pulse sset Master"
local cmd_get = "amixer -D pulse sget "
local volume_inc = volume_set .. " 5%+"
local volume_dec = volume_set .. " 5%-"
local volume_toggle = volume_set .. " toggle"

local get_level = function(channel, cb)
	awful.spawn.easy_async(cmd_get .. channel, function(out)
		local level, status = string.match(out, "%[(%d+)%%%] %[(%a+)%]")
		cb(level, status)
	end)
end

function M.volume_get_level(cb)
	get_level("Master", cb)
end

function M.mic_get_level(cb)
	get_level("Capture", cb)
end

local action = function(cmd)
	awful.spawn.easy_async(cmd, function()
		M.volume_get_level(function(level, status)
			local percentage = level .. "%"
			local text = status == "on" and "Volume: " .. percentage or "[Muted] " .. percentage

			-- if widget then
			awesome.emit_signal("widget::volume")
			-- end

			noti_obj = naughty.notify({
				replaces_id = noti_obj ~= nil and noti_obj.id or nil,
				text = text,
			})
		end)
	end)
end

M.increase = function()
	action(volume_inc)
end
M.decrease = function()
	action(volume_dec)
end
M.toggle = function()
	action(volume_toggle)
end

return M

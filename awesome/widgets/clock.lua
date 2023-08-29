local wibox = require("wibox")
local beautiful = require("beautiful")
local utils = require("utils")
local wbutton = require("widgets.components.button")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

--- Clock Widget
--- ~~~~~~~~~~~~

return function(s)
	local accent_color = beautiful.white
	local clock = wibox.widget({
		widget = wibox.widget.textclock,
		format = "%a %b %e %H:%M",
		align = "center",
		valign = "center",
		bottom = dpi(1),
		font = beautiful.font_name .. " Bold 11",
	})

	clock.markup = utils.ui.colorize_text(clock.text, accent_color)
	clock:connect_signal("widget::redraw_needed", function()
		clock.markup = utils.ui.colorize_text(clock.text, accent_color)
	end)

	local widget = wbutton.elevated.state({
		child = clock,
		normal_bg = beautiful.wibar_bg,
		on_release = function()
			-- awesome.emit_signal("info_panel::toggle", s)
			-- local focused = awful.screen.focused()
			awesome.emit_signal("central_panel::toggle", s)
		end,
	})

	return widget
end

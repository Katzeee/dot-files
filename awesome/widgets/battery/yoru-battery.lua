--- https://github.com/rxyhn/yoru

local wibox = require("wibox")
local beautiful = require("beautiful")
local power_daemon = require("widgets.battery.acpi-signal")
-- local power_daemon = require("widgets.battery.signal-battery")
local gears = require("gears")
local gobject = require("gears.object")
-- local apps = require("configuration.apps")
local dpi = require("beautiful").xresources.apply_dpi
local utils = require("utils")
local wbutton = require("widgets.components.button")
local awful = require("awful")

--- Battery Widget
--- ~~~~~~~~~~~~~~

return function()
	local happy_color = beautiful.white
	local sad_color = beautiful.red
	local ok_color = beautiful.yellow
	local charging_color = beautiful.green

	local charging_icon = wibox.widget({
		markup = utils.ui.colorize_text("󱐋 ", beautiful.green),
		font = beautiful.font,
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local battery_margin = (beautiful.bar_height - dpi(45)) / 2

	local battery_bar = wibox.widget({
		max_value = 100,
		value = 50,
		margins = {
			top    = battery_margin,
			bottom = battery_margin,
		},
		forced_width = dpi(30),
		border_width = dpi(1),
		paddings = dpi(2),
		bar_shape = utils.ui.rounded_rect(2),
		shape = utils.ui.rounded_rect(5),
		color = beautiful.white,
		background_color = beautiful.transparent,
		border_color = beautiful.white,
		widget = wibox.widget.progressbar,
	})

	local battery_right_dot_decoration = wibox.widget({
		{
			{
				widget = wibox.widget.textbox
			},
			widget = wibox.container.background,
			bg = beautiful.white,
			forced_width = dpi(8.2),
			forced_height = dpi(8.2),
			shape = function(cr, width, height)
				gears.shape.pie(cr, width, height, 0, math.pi)
			end,
		},
		direction = "east",
		widget = wibox.container.rotate,
	})

	local battery = wibox.widget({
		charging_icon,
		{
			battery_bar,
			battery_right_dot_decoration,
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(-1.6),
		},
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(1),
	})

	local battery_percentage_text = wibox.widget({
		id = "percent_text",
		text = "50%",
		-- font = beautiful.font_name .. "Medium 12",
		font = beautiful.font,
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local battery_widget = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(5),
		{
			battery,
			top = dpi(1),
			bottom = dpi(1),
			widget = wibox.container.margin,
		},
		battery_percentage_text,
	})

	local widget = wbutton.elevated.state({
		child = battery_widget,
		normal_bg = beautiful.wibar_bg,
		normal_shape = utils.ui.rounded_rect(20),
		on_release = function()
			local focused = awful.screen.focused()
			awesome.emit_signal("central_panel::toggle", focused)
			-- awful.spawn(apps.default.power_manager, false)
		end,
	})

	local last_value = 100

	power_daemon:connect_signal("no_devices", function(_)
		widget.visible = false
	end)

	-- is charging? is ac plugged?
	power_daemon:connect_signal("update", function(self, value, charging_state, ac_state)
		battery_bar.value = value
		last_value = value

		battery_percentage_text:set_text(math.floor(value) .. "%")

		if charging_state == 1 then
			battery_bar.color = charging_color
		elseif value <= 15 then
			battery_bar.color = sad_color
		elseif value <= 30 then
			battery_bar.color = ok_color
		else
			battery_bar.color = happy_color
		end

		if ac_state == 1 then
			charging_icon.visible = true
		elseif last_value <= 15 then
			charging_icon.visible = false
			battery_bar.color = sad_color
		elseif last_value <= 30 then
			charging_icon.visible = false
			battery_bar.color = ok_color
		else
			charging_icon.visible = false
			battery_bar.color = happy_color
		end
	end)

	return widget
end
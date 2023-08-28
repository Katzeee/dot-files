local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local widgets = require("widgets")
local utils = require("utils")
local gdebug = require("gears.debug")

local mute_text = ""
local unmute_text = ""

local action_level = widgets.button.text.normal({
	normal_shape = gears.shape.circle,
	font = beautiful.icon_font .. "Round ",
	size = 17,
	text_normal_bg = beautiful.accent,
	normal_bg = beautiful.one_bg3,
	text = unmute_text,
	paddings = dpi(5),
	animate_size = false,
	on_release = function()
		capture_mute_toggle()
	end,
})

local osd_value = wibox.widget({
	text = "0%",
	font = beautiful.font_name .. "Medium 13",
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local slider = wibox.widget({
	nil,
	{
		id = "mic_slider",
		shape = gears.shape.rounded_bar,
		bar_shape = gears.shape.rounded_bar,
		bar_color = beautiful.grey,
		bar_margins = { bottom = dpi(18), top = dpi(18) },
		bar_active_color = beautiful.accent,
		handle_color = beautiful.accent,
		handle_shape = gears.shape.circle,
		handle_width = dpi(15),
		handle_border_width = dpi(3),
		handle_border_color = beautiful.widget_bg,
		maximum = 100,
		widget = wibox.widget.slider,
	},
	nil,
	expand = "none",
	forced_width = dpi(200),
	layout = wibox.layout.align.vertical,
})

local mic_slider = slider.mic_slider

mic_slider:connect_signal("property::value", function()
	local mic_level = mic_slider:get_value()
	awful.spawn("amixer -D pulse sset Capture " .. mic_level .. "%", false)

	-- Update textbox widget text
	osd_value.text = mic_level .. "%"
end)

mic_slider:buttons(gears.table.join(
	awful.button({}, 4, nil, function()
		if mic_slider:get_value() > 100 then
			mic_slider:set_value(100)
			return
		end
		mic_slider:set_value(mic_slider:get_value() + 5)
	end),
	awful.button({}, 5, nil, function()
		if mic_slider:get_value() < 0 then
			mic_slider:set_value(0)
			return
		end
		mic_slider:set_value(mic_slider:get_value() - 5)
	end)
))

local update_slider = function()
	utils.volume.mic_get_level(function(level, status)
		gdebug.dump(level)
		gdebug.dump(status)
		mic_slider:set_value(tonumber(level))
		if status == "off" then
			action_level.text = mute_text
		elseif status == "on" then
			action_level.text = unmute_text
		end
		osd_value.text = level .. "%"
	end)
end

-- Update on startup
update_slider()

function capture_mute_toggle()
	awful.spawn.easy_async("amixer -D pulse sset Capture toggle", update_slider)
end

local mic_setting = wibox.widget({
	{
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(5),
		{
			layout = wibox.layout.align.vertical,
			expand = "none",
			nil,
			action_level,
			nil,
		},
	},
	slider,
	osd_value,
	layout = wibox.layout.fixed.horizontal,
	forced_height = dpi(42),
	spacing = dpi(17),
})

return mic_setting

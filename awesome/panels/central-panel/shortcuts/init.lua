local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local utils = require("utils")

--- Quick Settings
--- ~~~~~~~~~~~~~~

local quick_settings_text = wibox.widget({
	font = beautiful.font_name .. "Medium 10",
	markup = utils.ui.colorize_text("Quick Settings", "#666c79"),
	valign = "center",
	widget = wibox.widget.textbox,
})

--- Widgets
-- local airplane_mode = require(... .. ".airplane-mode")
local bluetooth = require(... .. ".bluetooth")
-- local dnd = require(... .. ".dnd")
local floating_mode = require(... .. ".floating-mode")
local screenshot_area = require(... .. ".screenshot").area
local screenshot_full = require(... .. ".screenshot").full

--- 4x4 grid of button
local buttons = wibox.widget({
	-- airplane_mode,
	-- blue_light,
	floating_mode,
	bluetooth,
	screenshot_area,
	-- microphone,
	-- dnd,
	screenshot_full,
	spacing = dpi(22),
	forced_num_cols = 4,
	forced_num_rows = 4,
	layout = wibox.layout.grid,
})

local widget = wibox.widget({
	{
		{
			{
				-- quick_settings_text,
				-- utils.ui.vertical_pad(dpi(10)),
				{
					buttons,
					left = dpi(12),
					right = dpi(12),
					widget = wibox.container.margin,
				},
				layout = wibox.layout.fixed.vertical,
			},
			top = dpi(19),
			bottom = dpi(19),
			left = dpi(10),
			right = dpi(10),
			widget = wibox.container.margin,
		},
		widget = wibox.container.background,
		forced_height = dpi(100),
		forced_width = dpi(350),
		bg = beautiful.widget_bg,
		shape = utils.ui.rrect(beautiful.border_radius),
	},
	margins = dpi(10),
	color = "#FF000000",
	widget = wibox.container.margin,
})

return widget

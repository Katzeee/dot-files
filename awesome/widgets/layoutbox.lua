local awful = require("awful")
local gears = require("gears")
local wbutton = require("widgets.components.button")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gdebug = require("gears.debug")

return function(s)
    local layoutbox_buttons = gears.table.join(
    --- Left click
        awful.button({}, 1, function(c)
            awful.layout.inc(1)
        end),

        --- Right click
        awful.button({}, 3, function(c)
            awful.layout.inc(-1)
        end),

        --- Scrolling
        awful.button({}, 4, function()
            awful.layout.inc(-1)
        end),
        awful.button({}, 5, function()
            awful.layout.inc(1)
        end)
    )

    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(layoutbox_buttons)
    -- gdebug.dump(s.mylayoutbox.children)

    local widget = wbutton.elevated.state({
        child = s.mylayoutbox,
        normal_bg = beautiful.wibar_bg,
    })

    return widget
end

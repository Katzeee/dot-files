local awful = require("awful")
local gears = require("gears")
local wbutton = require("widgets.components.button")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local gdebug = require("gears.debug") --- Systray
local animation = require("modules.animation")

--- ~~~~~~~
return function()
    local mysystray = wibox.widget.systray({
        reverse = true,
    })
    mysystray.base_size = beautiful.systray_icon_size

    local widget = wibox.widget({
        widget = wibox.container.constraint,
        strategy = "max",
        width = dpi(0),
        {
            widget = wibox.container.margin,
            margins = dpi(10),
            mysystray,
        },
    })

    local system_tray_animation = animation:new({
        easing = animation.easing.linear,
        duration = 0.125,
        update = function(self, pos)
            widget.width = pos
        end,
    })

    local arrow = wbutton.text.state({
        text_normal_bg = beautiful.accent,
        normal_bg = beautiful.wibar_bg,
        font = beautiful.icon_font .. "Round ",
        size = 18,
        text = "",
        on_turn_on = function(self)
            mysystray:set_screen(awful.screen.focused())
            system_tray_animation:set(400)
            self:set_text("")
        end,
        on_turn_off = function(self)
            system_tray_animation:set(0)
            self:set_text("")
        end,
    })

    return wibox.widget({
        layout = wibox.layout.fixed.horizontal,
        arrow,
        widget,
    })
end

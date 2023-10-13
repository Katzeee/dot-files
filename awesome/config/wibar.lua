local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local beautiful = require("beautiful")
local utils = require("utils")
local widgets = require("widgets")
local panel = require("panels")
local systray = widgets.systray()

local DEFAULT_OPTS = {
    widget_spacing = beautiful.spacing,
    bg = beautiful.transparent,
}

local wrap_bg = function(widgets, opts)
    opts = utils.misc.tbl_override(DEFAULT_OPTS, opts or {})

    if type(widgets) == "table" then
        widgets.spacing = opts.widget_spacing
    end

    return wibox.widget({
        {
            widgets,
            left = beautiful.spacing_lg,
            right = beautiful.spacing_lg,
            widget = wibox.container.margin,
        },
        shape = utils.ui.rounded_rect(20),
        bg = opts.bg,
        widget = wibox.container.background,
    })
end

awful.screen.connect_for_each_screen(function(s)
    utils.ui.set_wallpaper(s)

    s.mywibox = awful.wibar({
        height = beautiful.bar_height,
        type = "dock",
        bg = beautiful.wibar_bg,
        position = "top",
        screen = s,
        shape = beautiful.layoutlist_shape_selected,
        margins = {
            top = beautiful.useless_gap,
            left = beautiful.useless_gap * 2,
            right = beautiful.useless_gap * 2,

        },
    })

    widgets.taglist(s)
    panel.central_panel(s)

    s.mywibox:setup({
        {
            layout = wibox.layout.stack,
            {
                layout = wibox.layout.align.horizontal,
                { -- Left widgets
                    layout = wibox.layout.fixed.horizontal,
                    wrap_bg(s.mytaglist),
                },
                nil,

                { -- Right widgets
                    layout = wibox.layout.fixed.horizontal,
                    spacing = beautiful.spacing,
                    valign = "center",

                    systray,
                    widgets.yoru_battery(),
                    widgets.layoutbox(s),
                },
                widget = wibox.container.margin,
            },
            {
                widgets.clock(s),
                halign = "center",
                layout = wibox.container.place,
            },
            valign = "center",
        },
        widget = wibox.container.margin,
        top = beautiful.useless_gap,
        bottom = beautiful.useless_gap,
    }
    )
end)

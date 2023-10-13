local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local text = require("panels.central-panel.exit-screen.text")

-- Buttons
local buttons = require("panels.central-panel.exit-screen.buttons")

local separator = wibox.widget.textbox("    ")
separator.forced_width = dpi(90)

--Main powermenu wibox
return function(s)
    local s_width = s.geometry.width
    local s_height = s.geometry.height

    local background = wibox.widget.textbox(" ")
    background.forced_height = s_height
    background.forced_width = s_width


    s.lock_screen = awful.popup {
        screen = s,
        widget = wibox.container.background,
        ontop = true,
        bg = "#00000000",
        visible = false,
        placement = function(c)
            awful.placement.centered(c,
                { margins = { top = dpi(0), bottom = dpi(0), left = dpi(0), right = dpi(0) } })
        end,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 0)
        end,
        opacity = 1,
        forced_height = dpi(1080),
        forced_width = dpi(1920),
    }

    s.lock_screen:setup {
        {
            background,
            {
                {
                    {
                        buttons.shutdown,
                        separator,
                        buttons.reboot,
                        separator,
                        buttons.logout,
                        separator,
                        buttons.sleep,
                        separator,
                        buttons.lock,
                        layout = wibox.layout.fixed.horizontal
                    },
                    {
                        text,
                        widget = wibox.container.margin,
                        top = 40,
                    },
                    layout = wibox.layout.fixed.vertical
                },
                layout = wibox.container.place
            },
            layout = wibox.layout.stack
        },
        widget = wibox.container.background,
        bg = "#24283bff",
    }

    s.lock_screen:connect_signal("button::press", function(_, _, _, button)
        if button == 3 then
            -- awesome.emit_signal("widget::control")
            awful.screen.connect_for_each_screen(function(s)
                s.lock_screen.visible = false
            end)
        end
    end)

    awesome.connect_signal("central_panel::exit_screen::unshow", function()
        s.lock_screen.visible = false
    end)

    awesome.connect_signal("central_panel::exit_screen:show", function()
        s.lock_screen.visible = true
    end)
end

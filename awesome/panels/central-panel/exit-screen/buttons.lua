local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local icons = require("icons")
local text = require("panels.central-panel.exit-screen.text")

local function create_button(img, hover_img, description, command, hover_color)
    --Imagebox
    local image = wibox.widget {
        widget = wibox.widget.imagebox,
        image = icons.icons_path .. "exit-screen/" .. img .. ".png",
        resize = true,
        opacity = 1,
    }

    --Main Widget
    local buttons = wibox.widget {
        {
            image,
            left   = dpi(35),
            right  = dpi(35),
            top    = dpi(35),
            bottom = dpi(35),
            widget = wibox.container.margin
        },
        bg = beautiful.black,
        shape = gears.shape.rounded_rect,
        widget = wibox.container.background,
        forced_height = dpi(150),
        forced_width = dpi(150),
        border_width = dpi(5),
        border_color = beautiful.grey
    }

    --Functionality
    buttons:connect_signal("mouse::enter", function()
        buttons.border_color = hover_color
        image.image = icons.icons_path .. "exit-screen/" .. hover_img .. ".png"
        text:set_markup_silently('<span color="' ..
            hover_color .. '" font="Ubuntu Nerd Font bold 28">' .. description .. '</span>')
    end)
    --
    buttons:connect_signal("mouse::leave", function()
        buttons.border_color = beautiful.grey
        image.image = icons.icons_path .. "exit-screen/" .. img .. ".png"
        text:set_markup_silently('<span color="' ..
            beautiful.white .. '" font="Ubuntu Nerd Font 28">' .. " " .. '</span>')
    end)


    buttons:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then
            awful.spawn.with_shell(command)
            awesome.emit_signal("central_panel::exit_screen::unshow")
        end
    end)

    return buttons
end

local powermenu_buttons = {
    lock = create_button('lock', 'lock-hover', 'Lock Screen', 'slock', beautiful.color2),
    logout = create_button('logout', 'logout-hover', 'Logout', '', beautiful.color5),
    reboot = create_button('restart', 'restart-hover', 'Reboot', 'reboot', beautiful.color3),
    shutdown = create_button('power', 'power-hover', 'Power Off', 'shutdown -h now', beautiful.color1),
    sleep = create_button('power-sleep', 'power-sleep-hover', 'Sleep', '', beautiful.color6)
}

powermenu_buttons.logout:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
        awesome.quit()
    end
end)


return powermenu_buttons

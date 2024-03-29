local awful = require("awful")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local utils = require("utils")
local gears = require("gears")
-- local icons = require("icons")

--- AWESOME Central panel
--- ~~~~~~~~~~~~~~~~~~~~~

return function(s)
    --- Header
    local function header()
        local dashboard_text = wibox.widget({
            markup = utils.ui.colorize_text("Another awesome day!", "#666c79"),
            font = beautiful.font_name .. "Bold 14",
            valign = "center",
            align = "center",
            widget = wibox.widget.textbox(),
        })

        local function search_box()
            local search_icon = wibox.widget({
                font = "icomoon bold 12",
                align = "center",
                valign = "center",
                widget = wibox.widget.textbox(),
            })

            local reset_search_icon = function()
                search_icon.markup = utils.ui.colorize_text("", beautiful.accent)
                -- search_icon.markup = utils.ui.colorize_text(" ", beautiful.accent)
            end
            reset_search_icon()

            local search_text = wibox.widget({
                --- markup = helpers.ui.colorize_text("Search", beautiful.color8),
                align = "center",
                valign = "center",
                font = beautiful.font_name .. "Bold 12",
                widget = wibox.widget.textbox(),
            })

            local search = wibox.widget({
                {
                    {
                        search_icon,
                        {
                            search_text,
                            bottom = dpi(2),
                            widget = wibox.container.margin,
                        },
                        layout = wibox.layout.fixed.horizontal,
                    },
                    left = dpi(15),
                    widget = wibox.container.margin,
                },
                forced_height = dpi(35),
                forced_width = dpi(420),
                shape = gears.shape.rounded_bar,
                bg = beautiful.wibar_bg,
                widget = wibox.container.background(),
            })

            local function generate_prompt_icon(icon, color)
                return "<span font='JetBrainsMono NF ExtraLight 12' foreground='" .. color .. "'>" .. icon .. "</span> "
            end

            local function activate_prompt(action)
                search_icon.visible = false
                local prompt
                if action == "run" then
                    prompt = generate_prompt_icon(" ", beautiful.accent)
                elseif action == "web_search" then
                    prompt = generate_prompt_icon("󰥨 ", beautiful.accent)
                end
                utils.misc.prompt(action, search_text, prompt, function()
                    search_icon.visible = true
                end)
            end

            search:buttons(gears.table.join(
                awful.button({}, 1, function()
                    activate_prompt("run")
                end),
                awful.button({}, 3, function()
                    activate_prompt("web_search")
                end)
            ))

            search:connect_signal("mouse::leave", function(c)
                search = nil
                -- c:deactivate()
            end)

            return search
        end

        local widget = wibox.widget({
            {
                nil,
                dashboard_text,
                nil,
                -- search_box(),
                layout = wibox.layout.align.horizontal,
            },
            margins = dpi(10),
            widget = wibox.container.margin,
        })

        return widget
    end

    s.awesomewm = wibox.widget({
        {
            {
                -- image = gears.color.recolor_image(icons.awesome_logo, beautiful.accent),
                resize = true,
                halign = "center",
                valign = "center",
                widget = wibox.widget.imagebox,
            },
            strategy = "exact",
            height = dpi(40),
            widget = wibox.container.constraint,
        },
        margins = dpi(10),
        widget = wibox.container.margin,
    })

    --- Widgets
    -- s.stats = require("ui.panels.central-panel.stats")
    s.user_profile = require("panels.central-panel.user-profile")
    s.shortcuts = require("panels.central-panel.shortcuts")
    s.slider = require("panels.central-panel.slider")
    -- s.music_player = require("ui.panels.central-panel.music-player")
    s.calendar = require("panels.central-panel.calendar")()
    local calendar = wibox.widget({
        {
            {
                s.calendar,
                margins = dpi(16),
                widget = wibox.container.margin,
            },
            bg = beautiful.widget_bg,
            shape = utils.ui.rrect(beautiful.border_radius),
            widget = wibox.container.background,
        },
        margins = dpi(10),
        widget = wibox.container.margin,
    })

    s.central_panel = awful.popup({
        type = "dock",
        screen = s,
        minimum_height = dpi(560),
        maximum_height = dpi(700),
        minimum_width = dpi(700),
        maximum_width = dpi(800),
        bg = beautiful.transparent,
        ontop = true,
        visible = false,
        placement = function(w)
            awful.placement.top(w, {
                margins = { top = beautiful.bar_height + dpi(10), bottom = dpi(5), left = dpi(5), right = dpi(5) },
            })
        end,
        shape = utils.ui.rrect(beautiful.border_radius),
        widget = {
            {
                {
                    header(),
                    margins = {
                        -- top = dpi(10),
                        -- bottom = dpi(10),
                        right = dpi(20),
                        left = dpi(20)
                    },
                    widget = wibox.container.margin,
                },
                {
                    {
                        {
                            nil,
                            {
                                {
                                    s.user_profile,
                                    s.shortcuts,
                                    s.slider,
                                    layout = wibox.layout.fixed.vertical,
                                },
                                {
                                    calendar,
                                    -- s.stats,
                                    -- s.music_player,
                                    -- s.awesomewm,
                                    layout = wibox.layout.fixed.vertical,
                                },
                                layout = wibox.layout.align.horizontal,
                            },
                            layout = wibox.layout.align.vertical,
                        },
                        margins = dpi(10),
                        widget = wibox.container.margin,
                    },
                    shape = utils.ui.prrect(beautiful.border_radius * 2, true, true, false, false),
                    bg = beautiful.wibar_bg,
                    widget = wibox.container.background,
                },
                layout = wibox.layout.align.vertical,
            },
            bg = beautiful.widget_bg,
            -- bg = beautiful.color3,
            widget = wibox.container.background,
        },
    })

    s.central_panel:connect_signal("mouse::leave", function(c)
        -- c:kill()
        s.central_panel.visible = false
    end)

    --- Toggle container visibility
    awesome.connect_signal("central_panel::toggle", function(scr)
        if scr == s then
            s.central_panel.visible = not s.central_panel.visible
        end
    end)
end

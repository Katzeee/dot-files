local gears = require("gears")
local awful = require("awful")
local constants = require("config.app")
local mods = constants.mods
local utils = require("utils")
local wibox = require("wibox")
local beautiful = require("beautiful")
local button = require("widgets.components.button")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({ mods.m }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ mods.m }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t)
        awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end)
)


return function(s)
    -- Each screen has its own tag table.
    awful.tag(utils.misc.range(1, 9), s, awful.layout.layouts[1])

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist({
        screen = s,
        buttons = taglist_buttons,
        filter = awful.widget.taglist.filter.all,
        layout = {
            layout = wibox.layout.fixed.horizontal,
            spacing = beautiful.spacing,
        },
        style = { shape = gears.shape.circle },
        widget_template =
        {
            {
                {
                    {
                        id = "text_role",
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left = beautiful.spacing,
                right = beautiful.spacing,
                widget = wibox.container.margin,
            },
            id = "background_role",
            widget = wibox.container.background,
        },
    })
end

-- local function tag_list(s)
--     local taglist = awful.widget.taglist({
--         screen = s,
--         filter = awful.widget.taglist.filter.all,
--         layout = { layout = wibox.layout.fixed.horizontal },
--         widget_template = {
--             widget = wibox.container.margin,
--             forced_width = dpi(40),
--             forced_height = dpi(40),
--             create_callback = function(self, c3, _)
--                 local indicator = wibox.widget({
--                     widget = wibox.container.place,
--                     valign = "center",
--                     {
--                         widget = wibox.container.background,
--                         forced_height = dpi(8),
--                         shape = gears.shape.rounded_bar,
--                     },
--                 })

--                 self.indicator_animation = animation:new({
--                     duration = 0.125,
--                     easing = animation.easing.linear,
--                     update = function(self, pos)
--                         indicator.children[1].forced_width = pos
--                     end,
--                 })

--                 self:set_widget(indicator)

--                 if c3.selected then
--                     self.widget.children[1].bg = beautiful.accent
--                     self.indicator_animation:set(dpi(32))
--                 elseif #c3:clients() == 0 then
--                     self.widget.children[1].bg = beautiful.color8
--                     self.indicator_animation:set(dpi(8))
--                 else
--                     self.widget.children[1].bg = beautiful.accent
--                     self.indicator_animation:set(dpi(16))
--                 end

--                 --- Tag preview
--                 self:connect_signal("mouse::enter", function()
--                     if #c3:clients() > 0 then
--                         awesome.emit_signal("bling::tag_preview::update", c3)
--                         awesome.emit_signal("bling::tag_preview::visibility", s, true)
--                     end
--                 end)

--                 self:connect_signal("mouse::leave", function()
--                     awesome.emit_signal("bling::tag_preview::visibility", s, false)
--                 end)
--             end,
--             update_callback = function(self, c3, _)
--                 if c3.selected then
--                     self.widget.children[1].bg = beautiful.accent
--                     self.indicator_animation:set(dpi(32))
--                 elseif #c3:clients() == 0 then
--                     self.widget.children[1].bg = beautiful.color8
--                     self.indicator_animation:set(dpi(8))
--                 else
--                     self.widget.children[1].bg = beautiful.accent
--                     self.indicator_animation:set(dpi(16))
--                 end
--             end,
--         },
--         buttons = taglist_buttons,
--     })

--     local widget = widgets.button.elevated.state({
--         normal_bg = beautiful.widget_bg,
--         normal_shape = gears.shape.rounded_bar,
--         child = {
--             taglist,
--             margins = { left = dpi(10), right = dpi(10) },
--             widget = wibox.container.margin,
--         },
--         on_release = function()
--             awesome.emit_signal("central_panel::toggle", s)
--         end,
--     })

--     return wibox.widget({
--         widget,
--         margins = dpi(5),
--         widget = wibox.container.margin,
--     })
-- end

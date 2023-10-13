local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local icons = require("icons")
local gears = require("gears")
local naughty = require("naughty")
local constants = require("config.app")
local utils = require("utils")

local theme = {}


--- ░█▀▀░█▀█░█░░░█▀█░█▀▄░█▀▀
--- ░█░░░█░█░█░░░█░█░█▀▄░▀▀█
--- ░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀

--- Special
theme.white = "#edeff0"
theme.darker_black = "#060809"
theme.black = "#0c0e0f"
theme.lighter_black = "#121415"
theme.one_bg = "#161819"
theme.one_bg2 = "#1f2122"
theme.one_bg3 = "#27292a"
theme.grey = "#343637"
theme.grey_fg = "#3e4041"
theme.grey_fg2 = "#484a4b"
theme.light_grey = "#505253"
theme.notification_bg = theme.black

theme.transparent = "#00000000"
theme.widget_bg = "#1b1d1e"

--- Black
theme.color0 = "#232526"
theme.color8 = "#2c2e2f"

--- Red
theme.color1 = "#df5b61"
theme.color9 = "#e8646a"

--- Green
theme.color2 = "#78b892"
theme.color10 = "#81c19b"

--- Yellow
theme.color3 = "#de8f78"
theme.color11 = "#e79881"

--- Blue
theme.color4 = "#6791c9"
theme.color12 = "#709ad2"

--- Magenta
theme.color5 = "#bc83e3"
theme.color13 = "#c58cec"

--- Cyan
theme.color6 = "#67afc1"
theme.color14 = "#70b8ca"

--- White
theme.color7 = "#e4e6e7"
theme.color15 = "#f2f4f5"

--- Background Colors
theme.bg_normal = theme.black
theme.bg_focus = theme.black
theme.bg_urgent = theme.black
theme.bg_minimize = theme.black

--- Foreground Colors
theme.fg_normal = theme.white
theme.fg_focus = theme.accent
theme.fg_urgent = theme.color1
theme.fg_minimize = theme.color0

--- Accent colors
function theme.random_accent_color()
    local accents = {
        theme.color9,
        theme.color10,
        theme.color11,
        theme.color12,
        theme.color13,
        theme.color14,
    }

    local i = math.random(1, #accents)
    return accents[i]
end

theme.accent = theme.color4


theme.font_name = "JetBrains Mono Nerd Font"
theme.font = theme.font_name .. " Bold 12"
theme.icon_font = "Material Icons "

-- spacing
theme.spacing = dpi(8)
theme.spacing_md = dpi(12)
theme.spacing_lg = dpi(16)
theme.spacing_xl = dpi(20)

-- border
theme.useless_gap = dpi(5)
theme.border_width = dpi(5)
theme.border_radius = dpi(8)
theme.border_focus = theme.accent
theme.border_normal = theme.bg_normal

-- taglist
theme.taglist_bg = theme.bg_normal
theme.taglist_bg_focus = theme.color4
theme.taglist_bg_urgent = theme.color1
theme.taglist_fg_urgent = theme.black
theme.taglist_fg_focus = theme.bg_normal
theme.taglist_fg_occupied = theme.color4

-- wallpaper
-- theme.wallpaper = gears.surface.load_uncached(constants.wallpapers .. "teal-liquid.jpg")

-- bar
theme.bar_height = dpi(50)
theme.wibar_bg = "#000000"

-- system tray
theme.systray_icon_spacing = dpi(4)
theme.systray_max_rows = 1
theme.bg_systray = theme.wibar_bg


-- ********************************* --
--
--              Naughty
--
-- ********************************* --

theme.notification_spacing = theme.spacing
-- local nc = naughty.config
-- nc.defaults.margin = theme.spacing_lg
-- nc.defaults.shape = utils.ui.rounded_rect()
-- nc.defaults.timeout = 5
-- nc.defaults['icon_size'] = dpi(50)
-- nc.padding = theme.spacing
-- nc.padding = theme.spacing_xl
-- nc.presets.critical.bg = theme.red
-- nc.presets.critical.fg = theme.bg_normal
-- nc.presets.low.bg = theme.bg_normal
-- nc.presets.normal.bg = theme.green
-- nc.presets.normal.fg = theme.bg_normal
-- nc.spacing = theme.spacing
-- theme.notification_max_width = dpi(400)
-- theme.notification_max_height = dpi(150)
-- theme.notification_font = "JetBrains Mono Nerd Font 10"

-- ********************************* --
--
--              Widgets
--
-- ********************************* --

-- layout
theme.layout_floating = icons.floating
theme.layout_max = icons.max
theme.layout_tile = icons.tile
theme.layout_dwindle = icons.dwindle
theme.layout_fairv = "F"
theme.layout_centered = icons.centered
theme.layout_mstab = icons.mstab
theme.layout_equalarea = icons.equalarea
theme.layout_machi = icons.machi
theme.layoutlist_shape_selected = utils.ui.rrect(theme.border_radius)
theme.layoutlist_bg_selected = theme.widget_bg
theme.tooltip_bg = theme.lighter_black
theme.tooltip_fg = theme.white
theme.tooltip_font = theme.font_name .. "Regular 10"

-- battery
-- theme.battery_happy = theme.fg_normal
-- theme.battery_tired = theme.yellow
-- theme.battery_sad = theme.red
-- theme.battery_charging = theme.green

-- calendar
-- theme.calendar_fg_header = theme.fg_normal
-- theme.calendar_fg_focus = theme.bg_normal
-- theme.calendar_fg_weekday = theme.green
-- theme.calendar_fg = theme.fg_normal
-- theme.calendar_bg = theme.bg_normal
-- theme.calendar_bg_focus = theme.green

theme.pfp = constants.misc .. "hatunemiku.png"

return theme

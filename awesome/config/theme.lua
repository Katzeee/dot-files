local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gears = require("gears")
local naughty = require("naughty")
local constants = require("config.app")
local utils = require("utils")

local theme = {}

theme.transparent = "#00000000"
theme.font = "JetBrains Mono Nerd Font Bold 12"
theme.fontname = "JetBrains Mono Nerd Font"

theme.black = "#16161D"
theme.red = "#E46876"
theme.yellow = "#F2D98C"
theme.orange = "#FFA066"
theme.green = "#A8C98FCC"
theme.white = "#D3D3D3"

-- bg
theme.bg_normal = theme.black
theme.bg_focus = theme.green
theme.bg_urgent = theme.red

-- fg
theme.fg_normal = theme.white
theme.fg_focus = theme.yellow
theme.fg_urgent = theme.white

-- spacing
theme.spacing = dpi(8)
theme.spacing_md = dpi(12)
theme.spacing_lg = dpi(16)
theme.spacing_xl = dpi(20)

-- border
theme.useless_gap = dpi(10)
theme.border_width = dpi(5)
theme.border_radius = dpi(10)
theme.border_focus = theme.bg_focus
theme.border_normal = theme.bg_normal

-- taglist
theme.taglist_bg = theme.bg_normal
theme.taglist_bg_focus = theme.green
theme.taglist_bg_urgent = theme.red
theme.taglist_fg_focus = theme.bg_normal
theme.taglist_fg_occupied = theme.green

-- wallpaper
-- theme.wallpaper = gears.surface.load_uncached(constants.wallpapers .. "teal-liquid.jpg")

-- bar
theme.bar_height = dpi(60)

-- system tray
theme.systray_icon_spacing = theme.spacing
theme.systray_max_rows = 7
theme.bg_systray = "#FFFFFF"

-- ********************************* --
--
--              Naughty
--
-- ********************************* --

local nc = naughty.config
nc.defaults.margin = theme.spacing_lg
nc.defaults.shape = utils.ui.rounded_rect()
nc.defaults.timeout = 500
nc.defaults['icon_size'] = dpi(50)
nc.padding = theme.spacing
nc.padding = theme.spacing_xl
nc.presets.critical.bg = theme.red
nc.presets.critical.fg = theme.bg_normal
nc.presets.low.bg = theme.bg_normal
nc.presets.normal.bg = theme.green
nc.presets.normal.fg = theme.bg_normal
nc.spacing = theme.spacing
theme.notification_max_width = dpi(400)
theme.notification_max_height = dpi(150)
theme.notification_font = "JetBrains Mono Nerd Font 10"

-- ********************************* --
--
--              Widgets
--
-- ********************************* --

-- battery
theme.battery_happy = theme.fg_normal
theme.battery_tired = theme.yellow
theme.battery_sad = theme.red
theme.battery_charging = theme.green

-- calendar
theme.calendar_fg_header = theme.fg_normal
theme.calendar_fg_focus = theme.bg_normal
theme.calendar_fg_weekday = theme.green
theme.calendar_fg = theme.fg_normal
theme.calendar_bg = theme.bg_normal
theme.calendar_bg_focus = theme.green

return theme

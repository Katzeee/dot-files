local gfs = require("gears.filesystem")
local dir = gfs.get_configuration_dir() .. "icons/"

local M = {}
--- layouts
M.floating = dir .. "layouts/floating.png"
M.max = dir .. "layouts/max.png"
M.tile = dir .. "layouts/tile.png"
M.dwindle = dir .. "layouts/dwindle.png"
M.centered = dir .. "layouts/centered.png"
M.mstab = dir .. "layouts/mstab.png"
M.equalarea = dir .. "layouts/equalarea.png"
M.machi = dir .. "layouts/machi.png"
return M

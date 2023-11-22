local gfs = require("gears.filesystem")

local M = {}

M.terminal = "alacritty"
M.editor = "nvim"
M.editor_cmd = M.terminal .. " -e " .. M.editor
M.mods = {
	m = "Mod4",
	s = "Shift",
	c = "Control",
}
M.wallpapers = gfs.get_configuration_dir() .. "../wallpapers/"
M.misc = gfs.get_configuration_dir() .. "Misc/"
M.full_screenshot = "flameshot full --clipboard"
M.area_screenshot = "flameshot gui --clipboard"
M.save_image_from_clipboard = "xclip -selection clipboard -t image/png -o > /tmp/screenshot.png"
M.show_screenshot = "feh --scale-down /tmp/screenshot.png"

return M

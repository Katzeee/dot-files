local M = {}
M.misc = require(... .. "./misc")
M.ui = require(... .. "./ui")
M.color = require(... .. "./color")
M.ibus = require(... .. "./ibus")()
M.volume = require(... .. "./volume")

return M

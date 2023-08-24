local tonumber = tonumber
local string = string
local math = math
local type = type
local floor = math.floor
local max = math.max
local min = math.min
local pow = math.pow
local random = math.random
local abs = math.abs
local format = string.format
local misc = require("utils.misc")
local gdebug = require("gears.debug")

local M = {}

--constants for clarity
local ANY = { "r", "g", "b", "h", "s", "l", "hex", "a" }
local ANYSUBHEX = { "r", "g", "b", "h", "s", "l", "a" }
local RGB = { "r", "g", "b" }
local HSL = { "h", "s", "l" }
local HEX = { "hex" }

--create a color object
local function color_obj(args)
	-- The object that will be returned
	local obj = { _props = {} }

	-- Default properties here
	obj._props.r = args.r or 0
	obj._props.g = args.g or 0
	obj._props.b = args.b or 0
	obj._props.h = args.h or 0
	obj._props.s = args.s or 0
	obj._props.l = args.l or 0
	obj._props.a = args.a or 1
	obj._props.hex = args.hex and args.hex:gsub("#", "") or "000000"

	obj._props.small_rgb = args.small_rgb or false

	-- Default actual normal properties
	obj.hashtag = args.hashtag or true
	obj.disable_hsl = args.disable_hsl or false

	-- Set access to any
	obj._access = ANY

	--temporary values
	--alpha since it can be nil and don't wanna overwrite,
	--hex_no_alpha just as a placeholder in _alphaize_hex
	local alpha, hex_no_alpha

	-- Methods and stuff
	function obj:_hex_to_rgba()
		local color = M.hex_to_rgba(obj._props.hex)
		obj._props.r = color.r
		obj._props.g = color.g
		obj._props.b = color.b
		if color.a then self._props.a = color.a end
		if obj._props.small_rgb then
			obj._props.r = math.floor(obj._props.r / 255)
			obj._props.g = math.floor(obj._props.g / 255)
			obj._props.b = math.floor(obj._props.b / 255)
		end
	end

	function obj:_rgba_to_hex()
		obj._props.hex = M.rgba_to_hex(obj._props)
	end

	function obj:_rgb_to_hsl()
		obj._props.h, obj._props.s, obj._props.l = M.rgb_to_hsl(obj._props)
	end

	function obj:_hsl_to_rgb()
		obj._props.r, obj._props.g, obj._props.b = M.hsl_to_rgb(obj._props)
	end

	function obj:_alphaize_hex()
		hex_no_alpha = #obj._props.hex == 6 and obj._props.hex or obj._props.hex:sub(1, 6)
		obj._props.hex = hex_no_alpha .. (obj._props.a ~= 1
			and string.format("%02x", math.floor(obj._props.a * 255)) or "")
	end

	function obj:set_no_update(key, value)
		obj._props[key] = value
	end

	-- Initially set other values
	if obj._props.r ~= 0 or obj._props.g ~= 0 or obj._props.b ~= 0 then
		obj:_rgba_to_hex()
		if not obj.disable_hsl then obj:_rgb_to_hsl() end
	elseif obj._props.hex ~= "000000" then
		obj:_hex_to_rgba()
		if not obj.disable_hsl then obj:_rgb_to_hsl() end
	elseif obj._props.h ~= 0 or obj._props.s ~= 0 or obj._props.l ~= 0 then
		obj:_hsl_to_rgb()
		obj:_rgba_to_hex()
	end --otherwise it's just black and everything is correct already


	-- Set up the metatable
	local mt = getmetatable(obj) or {}

	-- Check if it's already in _props to return it
	-- TODO: Only remake values if necessary
	mt.__index = function(self, key)
		if self._props[key] then
			-- Check if to just return nil for hsl
			if obj.disable_hsl and misc.contains(HSL, key) then return self._props[key] end

			-- Check if something in ANY isn't currently accessible
			if not misc.contains(obj._access, key) and misc.contains(ANY, key) then
				if obj._access == RGB then
					self:_rgba_to_hex()
					if not obj.disable_hsl then obj:_rgb_to_hsl() end
				elseif obj._access == HEX then
					self:_rgba_to_hex()
					if not obj.disable_hsl then obj:_rgb_to_hsl() end
				elseif obj._access == HSL then
					self:_hsl_to_rgb()
					self:_rgba_to_hex()
				elseif obj._access == ANYSUBHEX then
					self:_alphaize_hex()
				end

				-- Reset accessibleness
				obj._access = ANY
			end

			-- Check for hashtaginess
			if obj.hashtag and key == "hex" then return "#" .. self._props.hex end

			return self._props[key]
		else
			return rawget(self, key)
		end
	end

	mt.__newindex = function(self, key, value)
		if self._props[key] ~= nil then
			-- Set what values are currently accessible
			if misc.contains(RGB, key) then
				obj._access = RGB
			elseif misc.contains(HSL, key) and not obj.disable_hsl then
				obj._access = HSL
			elseif key == "hex" then
				obj._access = HEX
			elseif key == "a" then
				obj._access = ANYSUBHEX

				-- If it's not any of those and is small_rgb then update the rgb values
			elseif key == "small_rgb" and value ~= obj._props.small_rgb then
				if obj._props.small_rgb then
					obj._props.r = obj._props.r / 255
					obj._props.g = obj._props.g / 255
					obj._props.b = obj._props.b / 255
				else
					obj._props.r = math.floor(obj._props.r * 255)
					obj._props.g = math.floor(obj._props.g * 255)
					obj._props.b = math.floor(obj._props.b * 255)
				end
			end

			-- Set the new value
			self._props[key] = value

			-- If it's not part of _props just normally set it
		else
			rawset(self, key, value)
		end
	end

	-- performs an operation on the color and returns the new color
	local function operate(new, operator)
		local newcolor = color_obj { r = obj.r, g = obj.g, b = obj.b }
		local key = new:match("%a+")
		if operator == "+" then
			newcolor[key] = newcolor[key] + new:match("[%d\\.]+")
		elseif operator == "-" then
			newcolor[key] = newcolor[key] - new:match("[%d\\.]+")
		end
		-- newcolor.a = obj.a / 255
		return newcolor
	end

	mt.__add = function(_, new) return operate(new, "+") end
	mt.__sub = function(_, new) return operate(new, "-") end

	setmetatable(obj, mt)
	return obj
end




local function round(x, p)
	local power = 10 ^ (p or 0)
	return (x * power + 0.5 - (x * power + 0.5) % 1) / power
end

-- Returns a value that is clipped to interval edges if it falls outside the interval
local function clip(num, min_num, max_num)
	return max(min(num, max_num), min_num)
end

-- Converts the given hex color to rgba
-- function M.hex_to_rgb(color)
-- 	color = color:gsub("#", "")
-- 	return {
-- 		r = tonumber("0x" .. color:sub(1, 2)),
-- 		g = tonumber("0x" .. color:sub(3, 4)),
-- 		b = tonumber("0x" .. color:sub(5, 6)),
-- 		a = #color == 8 and tonumber("0x" .. color:sub(7, 8)) or 255,
-- 	}
-- end

-- Useful public methods
function M.hex_to_rgba(hex)
	hex = hex:gsub("#", "")
	return {
		r = tonumber("0x" .. hex:sub(1, 2)),
		g = tonumber("0x" .. hex:sub(3, 4)),
		b = tonumber("0x" .. hex:sub(5, 6)),
		--if alpha exists in hex, return it
		a = #hex == 8 and tonumber("0x" .. hex:sub(7, 8)) or 255
	}
end

-- Converts the given rgba color to hex
function M.rgb_to_hex(color)
	local r = clip(color.r or color[1], 0, 255)
	local g = clip(color.g or color[2], 0, 255)
	local b = clip(color.b or color[3], 0, 255)
	local a = clip(color.a or color[4] or 255, 0, 255)
	return "#" .. format("%02x%02x%02x%02x", floor(r), floor(g), floor(b), floor(a))
end

function M.rgba_to_hex(obj)
	local r = obj.r or obj[1]
	local g = obj.g or obj[2]
	local b = obj.b or obj[3]
	local a = obj.a or 1
	local h = (obj.hashtag or obj[4]) and "#" or ""
	return h .. string.format("%02x%02x%02x",
			math.floor(r),
			math.floor(g),
			math.floor(b))
		--this part only shows the alpha channel if it's not 1
		.. (a ~= 1 and string.format("%02x", math.floor(a * 255)) or "")
end

--no clue about any of this either
function M.hsl_to_rgb(obj)
	local h = obj.h or obj[1]
	local s = obj.s or obj[2]
	local l = obj.l or obj[3]

	local temp1, temp2, temp_r, temp_g, temp_b, temp_h

	-- Set the temp variables
	if l <= 0.5 then
		temp1 = l * (s + 1)
	else
		temp1 = l + s - l * s
	end

	temp2 = l * 2 - temp1

	temp_h = h / 360

	temp_r = temp_h + 1 / 3
	temp_g = temp_h
	temp_b = temp_h - 1 / 3


	-- Make sure it's between 0 and 1
	if temp_r ~= 1 then temp_r = temp_r % 1 end
	if temp_g ~= 1 then temp_g = temp_g % 1 end
	if temp_b ~= 1 then temp_b = temp_b % 1 end

	local rgb = {}

	-- Bunch of tests
	-- Once again I haven't the foggiest what any of this does
	for _, v in pairs({ { temp_r, "r" }, { temp_g, "g" }, { temp_b, "b" } }) do
		if v[1] * 6 < 1 then
			rgb[v[2]] = temp2 + (temp1 - temp2) * v[1] * 6
		elseif v[1] * 2 < 1 then
			rgb[v[2]] = temp1
		elseif v[1] * 3 < 2 then
			rgb[v[2]] = temp2 + (temp1 - temp2) * (2 / 3 - v[1]) * 6
		else
			rgb[v[2]] = temp2
		end
	end

	return
		round(rgb.r * 255),
		round(rgb.g * 255),
		round(rgb.b * 255)
end

--disclaimer I have no idea what any of the math does
function M.rgb_to_hsl(obj)
	local r = obj.r or obj[1]
	local g = obj.g or obj[2]
	local b = obj.b or obj[3]

	local R, G, B = r / 255, g / 255, b / 255
	local max, min = math.max(R, G, B), math.min(R, G, B)
	local l, s, h

	-- Get luminance
	l = (max + min) / 2

	-- short circuit saturation and hue if it's grey to prevent divide by 0
	if max == min then
		s = 0
		h = obj.h or obj[4] or 0
		return 0, 0, l
	end

	-- Get saturation
	if l <= 0.5 then
		s = (max - min) / (max + min)
	else
		s = (max - min) / (2 - max - min)
	end

	-- Get hue
	if max == R then
		h = (G - B) / (max - min) * 60
	elseif max == G then
		h = (2.0 + (B - R) / (max - min)) * 60
	else
		h = (4.0 + (R - G) / (max - min)) * 60
	end

	-- Make sure it goes around if it's negative (hue is a circle)
	if h ~= 360 then h = h % 360 end

	return h, s, l
end

-- Converts the given hex color to hsv
function M.hex_to_hsv(color)
	local color = M.hex_to_rgba(color)
	local C_max = max(color.r, color.g, color.b)
	local C_min = min(color.r, color.g, color.b)
	local delta = C_max - C_min
	local H, S, V
	if delta == 0 then
		H = 0
	elseif C_max == color.r then
		H = 60 * (((color.g - color.b) / delta) % 6)
	elseif C_max == color.g then
		H = 60 * (((color.b - color.r) / delta) + 2)
	elseif C_max == color.b then
		H = 60 * (((color.r - color.g) / delta) + 4)
	end
	if C_max == 0 then
		S = 0
	else
		S = delta / C_max
	end
	V = C_max

	return { h = H, s = S * 100, v = V * 100 }
end

--- Try to guess if a color is dark or light.
function M.is_dark(color)
	color = color_obj({ hex = color })

	return color.l <= 0.4
end

--- Check if a color is opaque.
function M.is_opaque(color)
	color = color_obj({ hex = color })

	return color.a == 0
end

-- Calculates the relative luminance of the given color
function M.relative_luminance(color)
	local function from_sRGB(u)
		-- return u <= 0.0031308 and 25 * u / 323 or pow(((200 * u + 11) / 211), 12 / 5)
		return u <= 0.0031308 and 25 * u / 323 or ((200 * u + 11) / 211) ^ (12 / 5)
	end

	color = color_obj({ hex = color })

	return 0.2126 * from_sRGB(color.r) + 0.7152 * from_sRGB(color.g) + 0.0722 * from_sRGB(color.b)
end

-- Calculates the contrast ratio between the two given colors
function M.contrast_ratio(fg, bg)
	return (M.relative_luminance(fg) + 0.05) / (M.relative_luminance(bg) + 0.05)
end

-- Returns true if the contrast between the two given colors is suitable
function M.is_contrast_acceptable(fg, bg)
	return M.contrast_ratio(fg, bg) >= 7 and true
end

-- Returns a bright-ish, saturated-ish, color of random hue
function M.rand_hex(lb_angle, ub_angle)
	return color_obj({
		h = random(lb_angle or 0, ub_angle or 360),
		s = 70,
		v = 90,
	}).hex
end

-- Rotates the hue of the given hex color by the specified angle (in degrees)
function M.rotate_hue(color, angle)
	color = color_obj({ hex = color })

	angle = clip(angle or 0, 0, 360)
	color.h = (color.h + angle) % 360

	return color.hex
end

function M.button_color(color, amount)
	color = color_obj({ hex = color })

	if M.is_dark(color.hex) then
		color = color + string.format("%fl", amount)
	else
		color = color - string.format("%fl", amount)
	end

	return color.hex
end

function M.lighten(color, amount)
	amount = amount or 0

	color = color_obj({ hex = color })
	color.l = color.l + amount

	return color.hex
end

function M.darken(color, amount)
	amount = amount or 0

	color = color_obj({ hex = color })
	color.l = color.l - amount

	return color.hex
end

-- Pywal like functions
function M.pywal_blend(color1, color2)
	color1 = color_obj({ hex = color1 })
	color2 = color_obj({ hex = color2 })

	return color_obj({
		r = round(0.5 * color1.r + 0.5 * color2.r),
		g = round(0.5 * color1.g + 0.5 * color2.g),
		b = round(0.5 * color1.b + 0.5 * color2.b),
	}).hex
end

function M.pywal_saturate_color(color, amount)
	color = color_obj({ hex = color })

	color.s = clip(amount, 0, 1)

	return color.hex
end

function M.pywal_alter_brightness(color, amount, sat)
	sat = sat or 0

	color = color_obj({ hex = color })

	color.l = clip(color.l + amount, 0, 1)
	color.s = clip(color.s + sat, 0, 1)

	return color.hex
end

function M.pywal_lighten(color, amount)
	color = color_obj({ hex = color })

	color.r = round(color.r + (255 - color.r) * amount)
	color.g = round(color.g + (255 - color.g) * amount)
	color.b = round(color.b + (255 - color.b) * amount)

	return color.hex
end

function M.pywal_darken(color, amount)
	color = color_obj({ hex = color })

	color.r = round(color.r * (1 - amount))
	color.g = round(color.g * (1 - amount))
	color.b = round(color.b * (1 - amount))

	return color.hex
end

return M

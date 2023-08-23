local gobject = require "gears.object"
local gtimer = require "gears.timer"
local watch = require("awful.widget.watch")

function new()
    local ret = gobject {}
    ret:emit_signal "test"


    watch("acpi -i", 10, function(_, stdout)
        local status, charge_str, _ =
            string.match(stdout, "Battery 0" .. ": ([%a%s]+), (%d?%d?%d)%%,?(.*)")

        if status == nil or charge_str == nil then
            ret:emit_signal "no_devices"
        end

        --------------------------------------------------------
        local level = math.floor(tonumber(charge_str))
        -- local tens = math.floor(level / 10) * 10

        local state = status == "Charging" and 1 or 0;
        ret:emit_signal("update", level, state)
    end)


    return ret
end

if not instance then
    instance = new()
end

return instance

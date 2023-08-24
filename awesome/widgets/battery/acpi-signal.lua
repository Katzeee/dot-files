local gobject = require "gears.object"
local gtimer = require "gears.timer"
local watch = require("awful.widget.watch")
local gdebug = require("gears.debug")

function new()
    local ret = gobject {}
    ret:emit_signal "test"


    watch("acpi -V", 10, function(_, stdout)
        local status, charge_str, _ =
            string.match(stdout, "Battery 0" .. ": ([%a%s]+), (%d?%d?%d)%%,?(.*)")

        local ac_status =
            string.match(stdout, "Adapter 0" .. ": (.*)-line")

        if status == nil or charge_str == nil then
            ret:emit_signal "no_devices"
        end

        --------------------------------------------------------
        local level = math.floor(tonumber(charge_str))
        -- local tens = math.floor(level / 10) * 10

        local charging_state = status == "Charging" and 1 or 0;
        local ac_state = ac_status == "on" and 1 or 0;
        ret:emit_signal("update", level, charging_state, ac_state)
    end)

    -- gdebug.dump("done")
    -- gdebug.dump(
    --     require("utils").color.button_color("#00000050", 0.1)
    -- )
    -- gdebug.dump("done")


    return ret
end

if not instance then
    instance = new()
end

return instance

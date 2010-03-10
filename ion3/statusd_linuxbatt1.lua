-- statusd_linuxbatt1.lua
--
-- Public domain
--
-- Uses the /proc/acpi interface to get batt1ery percentage.
--
-- Use the key "linuxbatt1" to get the batt1ery percentage; use
-- "linuxbatt1_state" to get a symbol indicating charging "+",
-- discharging "-", or charged " ".
--
-- Now uses lua functions instead of bash, awk, dc.  MUCH faster!
--
-- The "bat" option to the statusd settings for linuxbatt1 modifies which
-- batt1ery we look at.

local defaults={
        update_interval=15*1000,
        bat=0,
        important_threshold=30,
        critical_threshold=10,
}
local settings=table.join(statusd.get_config("linuxbatt1"), defaults)

function linuxbatt1_do_find_capacity()
        local f=io.open('/proc/acpi/battery/BAT'.. settings.bat ..'/info')
        local infofile=f:read('*a')
        f:close()
        local i, j, capacity = string.find(infofile, 'last full capacity:%s*(%d+) .*')
        return capacity
end

local capacity = linuxbatt1_do_find_capacity()

function get_linuxbatt1()
	
        local f=io.open('/proc/acpi/battery/BAT'.. settings.bat ..'/state')
	local statefile=f:read('*a')
	f:close()
        local i, j, remaining = string.find(statefile, 'remaining capacity:%s*(%d+) .*')
        local percent = math.floor( remaining * 100 / capacity )

        local i, j, statename = string.find(statefile, 'charging state:%s*(%a+).*')
        if statename == "charging" then
                return percent, "+"
        elseif statename == "discharging" then
                return percent, "-"
        else
                return percent, " "
        end
end

function update_linuxbatt1()
	local perc, state = get_linuxbatt1()
	statusd.inform("linuxbatt1", tostring(perc))
	statusd.inform("linuxbatt1_state", state)
        if perc < settings.critical_threshold
        then statusd.inform("linuxbatt1_hint", "critical")
        elseif perc < settings.important_threshold
        then statusd.inform("linuxbatt1_hint", "important")
        else statusd.inform("linuxbatt1_hint", "normal")
        end
	linuxbatt1_timer:set(settings.update_interval, update_linuxbatt1)
end

linuxbatt1_timer = statusd.create_timer()
update_linuxbatt1()

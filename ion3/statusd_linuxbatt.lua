-- statusd_linuxbatt.lua
--
-- Public domain
--
-- Uses the /proc/acpi interface to get battery percentage.
--
-- Use the key "linuxbatt" to get the battery percentage; use
-- "linuxbatt_state" to get a symbol indicating charging "+",
-- discharging "-", or charged " ".
--
-- Now uses lua functions instead of bash, awk, dc.  MUCH faster!
--
-- The "bat" option to the statusd settings for linuxbatt modifies which
-- battery we look at.

local defaults={
        update_interval=15*1000,
        bat= {0, 1, 2},
        important_threshold=30,
        critical_threshold=10,
}
local settings=table.join(statusd.get_config("linuxbatt"), defaults)

function linuxbatt_do_find_capacity()
	local c = {}

	for n, bat in pairs(settings.bat) do
        local f=io.open('/proc/acpi/battery/BAT'.. bat ..'/info')
		local i, j, capacity
		if f then
        	local infofile=f:read('*a')
        	f:close()
        	i, j, capacity = string.find(infofile, 'design capacity:%s*(%d+) .*')
		else
			capacity = nil
		end
        c[n] = capacity
	end
	return c
end

local capacity = linuxbatt_do_find_capacity()

function get_linuxbatt()
	local b = {}

	for n, bat in pairs(settings.bat) do
        local f=io.open('/proc/acpi/battery/BAT'.. bat ..'/state')
		if f then
			local statefile=f:read('*a')
			f:close()
        	local i, j, remaining = string.find(statefile, 'remaining capacity:%s*(%d+) .*')
        	local percent = math.floor( remaining * 100 / capacity[n] )

        	local i, j, statename = string.find(statefile, 'charging state:%s*(%a+).*')
        	if statename == "charging" then
                b[n] = {percent, "+"}
        	elseif statename == "discharging" then
                b[n] = { percent, "-"}
        	else
                b[n] = { percent, ""}
        	end
		else
			b[n] = nil
		end
	end
	return b
end

function update_linuxbatt()
	local bat = get_linuxbatt()
	local s = ""
	local p = 0
	for b, state in pairs(bat) do
		if state then
			if s ~= "" then s = s .. "/" end
			local perc = state[1];
			s = s .. tostring(perc) .. state[2]
			p = p+perc
		end
	end
	statusd.inform("linuxbatt", s)
	if p < settings.critical_threshold then
		statusd.inform("linuxbatt_hint", "critical")
   	elseif p < settings.important_threshold then
		statusd.inform("linuxbatt_hint", "important")
   	else
		statusd.inform("linuxbatt_hint", "normal")
	end
	linuxbatt_timer:set(settings.update_interval, update_linuxbatt)
 end

linuxbatt_timer = statusd.create_timer()
update_linuxbatt()

-- $Id: statusd_meminfo.lua 59 2006-11-14 11:17:02Z tibi $

-- statusd_temp.lua -- temperature monitor for notion statusbar

-- version : 0.1
-- date    : 2015-02-18
-- author  : 

-- Shows the processor temp of the system.
-- This script depends on the /sys filesystem and thus only works on Linux.

-- Example usage:
-- "temp: %cpu_temp".

-- This software is in the public domain.

	--------------------------------------------------------------------------------


local defaults = {
   update_interval = 1000, -- 1 second
}

local settings = table.join(statusd.get_config("temp"), defaults)

local temperature_timer = statusd.create_timer()
local trip_point

function math.round(num, idp)
   local mult = 10^(idp or 0)
   return math.floor(num  * mult + 0.5) / mult
end

local function get_tempinfo()
   local f = io.open('/sys/bus/acpi/devices/LNXTHERM:00/thermal_zone/temp', 'r')
   if f == nil then return nil end
   local s = f:read("*a")
   f:close()
   local t=string.match(s, '[0-9]+')
   return t
end

local function update_tempinfo()
   local t = get_tempinfo()
   if t ~= nil then
       statusd.inform("tempinfo_temperature", tostring(tonumber(t)/1000))
       if trip_point and tonumber(t) > tonumber(trip_point) then
           statusd.inform("tempinfo_hint", "critical")
       end
   end
   temperature_timer:set(settings.update_interval, update_tempinfo)
end

local f = io.open('/sys/bus/acpi/devices/LNXTHERM:00/thermal_zone/trip_point_1_temp', 'r')
if f == nil then
	trip_point = nil
else
	local s = f:read("*a")
	f:close()
	local t=string.match(s, '[0-9]+')
	trip_point = t
end

update_tempinfo()

-- EOF

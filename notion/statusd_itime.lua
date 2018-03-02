local defaults = {
	update_interval = 5000 -- 864 -- Not to miss any centibeat !
}

local settings    = table.join(statusd.get_config("itime"), defaults)
local itime_timer = statusd.create_timer()

local function update_itime()
	-- Get current UTC time in seconds add 1 hour for BMT
    -- then convert to beats
	local beats=((os.time()+3600)%86400)/86.4
	statusd.inform("itime", string.format("@%06.2f", beats))
	itime_timer:set(settings.update_interval, update_itime)
end

update_itime()

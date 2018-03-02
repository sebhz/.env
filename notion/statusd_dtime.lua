local defaults = {
	update_interval = 5000 -- 864 -- Not to miss any second !
}

local settings    = table.join(statusd.get_config("dtime"), defaults)
local dtime_timer = statusd.create_timer()

local function update_dtime()
	-- Get current time in seconds
    -- then convert to decimal time
	local dt=(os.time(os.date("*t"))%86400)/8640
	statusd.inform("dtime", string.format("%.4f", dt))
	dtime_timer:set(settings.update_interval, update_dtime)
end

update_dtime()

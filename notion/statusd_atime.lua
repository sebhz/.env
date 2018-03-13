--[[
Alternate ways to display time.

%atime_itime will display the Internet Time in beats, see https://en.wikipedia.org/wiki/Swatch_Internet_Time
%atime_dtime will display the current decimal time, see https://en.wikipedia.org/wiki/Decimal_Time
%atime_ttime will display the current duodecimal time, see https://en.wikipedia.org/wiki/Duodecimal

]]--

local defaults = {
	update_interval = 5000,
}

local SEC_PER_DAY = 86400
local settings    = table.join(statusd.get_config("atime"), defaults)
local atime_timer = statusd.create_timer()

-- From number to base-n string
local function basen(n, b)
    n = math.floor(n)
    if not b or b == 10 then return tostring(n) end
    local digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local t = {}

    repeat
        local d = (n % b) + 1
        n = math.floor(n / b)
        table.insert(t, 1, digits:sub(d,d))
    until n == 0

    return table.concat(t,"")
end

local function update_atime()
	-- Get current time in seconds
	local _ = os.date("*t")
	local dt=_.hour*3600 + _.min*60 + _.sec

	-- Divide by one tenth of a day to obtain decimal time
	statusd.inform("atime_dtime", string.format("%.4f", dt/(SEC_PER_DAY/10)))

	-- Convert seconds to duodecimal clock hands
	local BASE = 12
	local diurnal, unqua, nilqua, uncia =
		dt/(SEC_PER_DAY/BASE),
		(dt%(SEC_PER_DAY/BASE))/(SEC_PER_DAY/BASE/BASE),
		(dt%(SEC_PER_DAY/BASE/BASE))/(SEC_PER_DAY/BASE/BASE/BASE),
		(dt%(SEC_PER_DAY/BASE/BASE/BASE))*BASE*BASE/(SEC_PER_DAY/BASE/BASE/BASE) -- Between 0 and 12*12 -> decimal part with 2 digits
	-- Display all this in the right base
	v = basen(uncia, BASE)
	v = v:len() < 2 and '0'..v or v -- Need to add a zero in case the last digit is alone
	statusd.inform("atime_ttime", basen(diurnal, BASE)..basen(unqua, BASE)..basen(nilqua, BASE).."."..v)

	-- Get current UTC time in seconds add 1 hour for BMT
	-- then convert to beats
	local _ = os.date("!*t")
	local dt=_.hour*3600 + _.min*60 + _.sec + 3600
	statusd.inform("atime_itime", string.format("@%06.2f", dt/86.4))

	atime_timer:set(settings.update_interval, update_atime)
end

update_atime()

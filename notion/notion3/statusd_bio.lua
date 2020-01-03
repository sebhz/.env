local defaults = {
	day = 28.75,
	month = 4,
	year  = 1973,
	update_interval = 6048*1000,
	critical_threshold = 0.9,
	important_threshold = 0.75
}

local settings = table.join(statusd.get_config("bio"), defaults)
local bio_timer = statusd.create_timer()
local seconds_per_day = 24.0 * 60.0 * 60.0
local pi2 = 2*math.pi

local function round (x, decimal)
	if decimal == nil then decimal = 0 end
	local p = 10^decimal
	local y = x*p

	if x >= 0 then
		return math.floor(y + 0.5)/p
	end

	return math.ceil(y - 0.5)/p
end

local function cal_to_jd(yr, mo, day, gregorian)
	mo = mo or 1
	day = day or 1
	if gregorian == nil then gregorian = true end

	local a = math.floor((14-mo)/12)
	local y = yr + 4800 - a
	local m = mo + 12*a -3

	local jdn = day + math.floor((153*m+2)/5)+365*y+math.floor(y/4)-32083.5
	if not gregorian then
		return jdn
	else
		return jdn - math.floor(y/100)+math.floor(y/400)+38
	end
end

local function slope(t, period)
	local derivative = math.cos(pi2*t/period)
	if derivative < 0 then
		return "-"
	elseif derivative > 0 then
		return "+"
	else
		return "="
	end
end

local function biorhythm(jd_origin, jd_current)
	local bio = {
		{name = "physical", cycle = 23, abbr = "p" },
		{name = "emotional", cycle = 28, abbr = "e" },
		{name = "intellectual", cycle = 33, abbr = "i" },
	}

	local derivate = function(t)
		local d = 0
		for i, v in pairs(bio) do
			d = d + pi2/v.cycle*math.cos(pi2*t/v.cycle)
		end
		return d
	end

	local mean = 0
	local n = 0

	if jd_current == nil then
		local d = os.date("*t")
		local fday = (d.hour*3600+d.min*60+d.sec)/seconds_per_day
		jd_current = cal_to_jd(d.year, d.month, d.day+fday)
	end

	local t = jd_current-jd_origin

	for i, v in pairs(bio) do
		v.value = round(math.sin(pi2*t/v.cycle), 2)
		v.slope = slope(t, v.cycle)
		n = n + 1
		mean = mean + v.value
	end

	local mean_table = {name= "mean", abbr= "=", value = mean/n}
	local d = derivate(t)
	if d < 0 then mean_table.slope = "-" elseif d > 0 then mean_table.slope = "+" else mean_table.slope = "=" end
	table.insert(bio, mean_table)

    return bio
end

local function update_bio()
	local bio, n = biorhythm(cal_to_jd(settings.year, settings.month, settings.day))

	local bio_str = ""
	local abb_str = ""
	local mean = 0

	for i, v in ipairs(bio) do
		abb_str = abb_str..v.abbr
		bio_str = bio_str..string.format("%+.2f", v.value)..v.slope
		if v.name ~= "mean" then bio_str = bio_str.."/" else mean = v.value end
	end

	statusd.inform("bio", abb_str..": "..bio_str)

	if mean > settings.critical_threshold or mean < -settings.critical_threshold then
		statusd.inform("bio_hint", "critical")
	elseif mean > settings.important_threshold or mean < -settings.important_threshold then
		statusd.inform("bio_hint", "important")
	else
		statusd.inform("bio_hint", "normal")
	end

	bio_timer:set(settings.update_interval, update_bio)
end

update_bio()

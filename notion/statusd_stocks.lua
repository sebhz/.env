local defaults = {
	syms = {'txn', 'intl' },
	disp_interval = 15 * 1000,
	refresh_every = 20,
	critical_slope_percent = 1,
	important_slope_percent = 0.75
}

local settings = table.join(statusd.get_config("stocks"), defaults)
local stocks_timer = statusd.create_timer()
local stocks_str, stocks_cmd
local stocks_prices = {}
local disp_index = 1
local update_mod = settings.refresh_every

-- Compatibility: Lua-5.1
-- Should be compatible with python split()
-- Modify the string class is probably not a good idea :-)
function string:split(delim, maxNb)
	local delim = delim or ","
    -- Eliminate bad cases...
    if self:find(delim) == nil then
        return { self }
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0    -- No limit
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in self:gmatch(pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = self:sub(lastPos)
    end
    return result
end

local function update_display()
	local sym = settings.syms[disp_index]
	local trend
	local v = tonumber(stocks_prices[sym][2])
	if v == nil then
		statusd.inform("stocks", "-----: ---")
		return
	end

	if v < 0 then
		trend = "-"
	else
		if v > 0 then
			trend = "+"
		else
			trend = "="
		end
	end
	statusd.inform("stocks", string.format("%-4s: %.3f%s", sym, stocks_prices[sym][1], trend))
	disp_index = disp_index + 1
	if disp_index > #settings.syms then disp_index = 1 end
end

local function update_stocks()
	-- TODO - handle error case
	if update_mod >= settings.refresh_every then
		local handle = io.popen(stocks_cmd)
		local res = handle:read("*a")
		handle:close()
		if res ~= nil then
			local v = res:split('\n')
			for i, k in ipairs(settings.syms) do stocks_prices[k] = v[i]:split(",") end
			update_mod = 1
		end
	else
		update_mod = update_mod + 1
	end

	update_display()
	stocks_timer:set(settings.disp_interval, update_stocks)
end

for i, v in ipairs(settings.syms) do
	if i == 1 then stocks_str = v else stocks_str = stocks_str .. "," .. v end
end
stocks_cmd ="curl -s 'http://download.finance.yahoo.com/d/quotes.csv?s=" .. stocks_str .. "&f=l1c1'"

update_stocks()


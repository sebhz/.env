local defaults = {
	update_interval = 1000,
	command = 'fortune',
	formatting = "scroll",             -- Can be "none", "split" or "scroll"
	scroll_strategy = "word",          -- Can be "word" or "character". Used only in scroll mode
	scroll_separator_string = " *-* ", -- Any string. Used only in scroll mode
	max_line_size = 20,
	start_marker = "",
	end_marker=""
}

local settings = table.join(statusd.get_config("pexec"), defaults)
local curstring = nil
local pos = 1
local as = settings.max_line_size-string.len(settings.start_marker)-string.len(settings.end_marker)

local function get_command_result()
    local f=io.popen(settings.command)
    if f then
        local bs=f:read('*all')
        f:close()
        local s = string.gsub(string.gsub(bs, "\n", " "), "%s+", " ")
        return(s)
    end
    return("?")
end

local function pexec_next_string()
	if settings.formatting == "none" then
		return(settings.start_marker..get_command_result()..settings.end_marker)
	end

	if settings.formatting == "split" then
		if (curstring == nil) or (pos > string.len(curstring)) then
			curstring = get_command_result()
			pos = 1
		end
		local s = string.sub(curstring, pos, pos+as-1)
		pos = pos+as
		return(settings.start_marker..s..settings.end_marker)
	end

	if settings.formatting == "scroll" then
		if settings.scroll_strategy == "character" then
			if curstring == nil then
				curstring = get_command_result()
				pos = 1
			end
			if pos >= string.len(curstring)-as+1 then
				curstring = string.sub(curstring, pos)..settings.scroll_separator_string..get_command_result()
				pos = 1
			end
			local s = string.sub(curstring, pos, pos+as-1)
			pos = pos+1
			return(settings.start_marker..s..settings.end_marker)
		end

		if settings.scroll_strategy == "word" then
		    -- Initial condition
			if curstring == nil then
				curstring = get_command_result()
				pos = as+1
				while string.sub(curstring, pos, pos) ~= " " do
					pos = pos - 1
				end
				while string.sub(curstring, pos, pos) == " " do
					pos = pos - 1
				end
				return(settings.start_marker..string.sub(curstring, 1, pos)..settings.end_marker)
			end

			-- Manage end of string
			if pos == string.len(curstring) then
				curstring = string.sub(curstring, pos-as+1)..settings.scroll_separator_string..get_command_result()
				pos = as
				while string.sub(curstring, pos, pos) == " " do
					pos = pos + 1
				end
				while string.sub(curstring, pos, pos) ~= " " do
					pos = pos + 1
				end
				return(settings.start_marker..string.sub(curstring, pos-as+1, pos)..settings.end_marker)
			end

			-- At this stage, pos points to the end of a word: add the next word to the list
			repeat pos = pos+1
			until string.sub(curstring, pos, pos) ~= " " or pos == string.len(curstring)
			repeat pos = pos+1
			until string.sub(curstring, pos, pos) == " " or pos == string.len(curstring)+1
			pos = pos-1
			local bpos = pos-as+1
			if bpos < 1 then bpos = 1 end
			return(settings.start_marker..string.sub(curstring, bpos, pos)..settings.end_marker)
		end
	end
end

local function update_pexec()
	local s = pexec_next_string()
	statusd.inform("pexec", s)
	pexec_timer:set(settings.update_interval, update_pexec)
end

pexec_timer = statusd.create_timer()
update_pexec()

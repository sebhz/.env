-- Automatically close empty frames when the last 
-- client is killed
local function close_empty_frame(ftable)
    if ftable.mode ~= 'remove' then return end
    local wmp = ftable.reg
    if WMPlex.mx_count(wmp) == 0 then
        ioncore.defer(function() WRegion.rqclose(wmp) end)
    end
end

local hk=ioncore.get_hook("frame_managed_changed_hook")
hk:add(close_empty_frame)


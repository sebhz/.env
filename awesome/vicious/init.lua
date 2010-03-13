---------------------------------------------------
-- Vicious widgets for the awesome window manager
---------------------------------------------------
-- Licensed under the GNU General Public License v2
--  * (c) 2010, Adrian C. <anrxc@sysphere.org>
--  * (c) 2009, Lucas de Vries <lucas@glacicle.com>
---------------------------------------------------

-- {{{ Grab environment
local type  = type
local pairs = pairs
local tonumber = tonumber
local helpers  = require("vicious.helpers")
local capi  = { timer = timer }
local os    = { time = os.time }
local table = {
    insert  = table.insert,
    remove  = table.remove
}
-- }}}


-- {{{ Configure widgets
require("vicious.cpu")
--require("vicious.cpuinf")
--require("vicious.cpufreq")
--require("vicious.thermal")
--require("vicious.uptime")
require("vicious.bat")
require("vicious.mem")
--require("vicious.os")
require("vicious.fs")
--require("vicious.dio")
--require("vicious.hddtemp")
--require("vicious.net")
--require("vicious.wifi")
--require("vicious.mbox")
--require("vicious.mboxc")
--require("vicious.mdir")
--require("vicious.gmail")
--require("vicious.entropy")
--require("vicious.org")
--require("vicious.pkg")
--require("vicious.mpd")
--require("vicious.volume")
--require("vicious.weather")
require("vicious.date")
-- }}}

-- Vicious: widgets for the awesome window manager
module("vicious")


-- {{{ Initialize tables
local timers       = {}
local registered   = {}
local widget_cache = {}

-- Initialize the function table
widgets = {}
-- }}}

-- {{{ Widget types
for i, w in pairs(_M) do
    -- Ensure we don't call ourselves
    if w and w ~= _M and type(w) == "table" then
        -- Ignore the function table and helpers
        if i ~= "widgets" and i ~= "helpers" then
            -- Place widgets in the namespace table
            widgets[i] = w
        end
    end
end
-- }}}


-- {{{ Local functions
-- {{{ Update a widget
local function update(widget, reg, disablecache)
    -- Check if there are any equal widgets
    if reg == nil then
        for w, i in pairs(registered) do
            if w == widget then
                for _, r in pairs(i) do
                    update(w, r, disablecache)
                end
            end
        end

        return
    end

    local t = os.time()
    local data = {}

    -- Check for chached output newer than the last update
    if widget_cache[reg.wtype] ~= nil then
        local c = widget_cache[reg.wtype]

        if (c.time == nil or c.time <= t-reg.timer) or disablecache then
            c.time, c.data = t, reg.wtype(reg.format, reg.warg)
        end

        data = c.data
    else
        data = reg.wtype(reg.format, reg.warg)
    end

    if type(data) == "table" then
        if type(reg.format) == "string" then
            data = helpers.format(reg.format, data)
        elseif type(reg.format) == "function" then
            data = reg.format(widget, data)
        end
    end

    if widget.add_value ~= nil then
        widget:add_value(data and tonumber(data) / 100)
    elseif widget.set_value ~= nil then
        widget:set_value(data and tonumber(data) / 100)
    else
        widget.text = data
    end

    return data
end
-- }}}

-- {{{ Register from reg object
local function regregister(reg)
    if not reg.running then
        if registered[reg.widget] == nil then
            registered[reg.widget] = {}
            table.insert(registered[reg.widget], reg)
        else
            local already = false

            for w, i in pairs(registered) do
                if w == reg.widget then
                    for _, v in pairs(i) do
                        if v == reg then
                            already = true
                            break
                        end
                    end

                    if already then
                        break
                    end
                end
            end

            if not already then
                table.insert(registered[reg.widget], reg)
            end
        end

        -- Start the timer
        if reg.timer > 0 then
            timers[reg.update] = {
                timer = capi.timer({ timeout = reg.timer })
            }
            timers[reg.update].timer:add_signal("timeout", reg.update)
            timers[reg.update].timer:start()
        end

        -- Initial update
        reg.update()
        reg.running = true
    end
end
-- }}}
-- }}}


-- {{{ Exposed functions
-- {{{ Register a widget
function register(widget, wtype, format, timer, warg)
    local reg = {}
    local widget = widget

    -- Set properties
    reg.wtype  = wtype
    reg.format = format
    reg.timer  = timer
    reg.warg   = warg
    reg.widget = widget

    -- Update function
    reg.update = function ()
        update(widget, reg)
    end

    -- Default to 2s timer
    if reg.timer == nil then
        reg.timer = 2
    end

    -- Register a reg object
    regregister(reg)

    -- Return a reg object for reuse
    return reg
end
-- }}}

-- {{{ Unregister a widget
function unregister(widget, keep, reg)
    if reg == nil then
        for w, i in pairs(registered) do
            if w == widget then
                for _, v in pairs(i) do
                    reg = unregister(w, keep, v)
                end
            end
        end

        return reg
    end

    if not keep then
        for w, i in pairs(registered) do
            if w == widget then
                for k, v in pairs(i) do
                    if v == reg then
                        table.remove(registered[w], k)
                    end
                end
            end
        end
    end

    -- Stop the timer
    if timers[reg.update].timer.started then
        timers[reg.update].timer:stop()
    end
    reg.running = false

    return reg
end
-- }}}

-- {{{ Enable caching of a widget type
function cache(wtype)
    if widget_cache[wtype] == nil then
        widget_cache[wtype] = {}
    end
end
-- }}}

-- {{{ Force update of widgets
function force(widgets)
    if type(widgets) == "table" then
        for _, w in pairs(widgets) do
            update(w, nil, true)
        end
    end
end
-- }}}

-- {{{ Suspend all widgets
function suspend()
    for w, i in pairs(registered) do
        for _, v in pairs(i) do
            unregister(w, true, v)
        end
    end
end
-- }}}

-- {{{ Activate a widget
function activate(widget)
    for w, i in pairs(registered) do
        if widget == nil or w == widget then
            for _, v in pairs(i) do
                regregister(v)
            end
        end
    end
end
-- }}}
-- }}}
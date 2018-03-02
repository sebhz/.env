--
-- Ion statusbar module configuration file
-- 
local template
local battmon_string = ""
local mocmon_string = ""
local tempmon_string = ""

local _f=io.open('/proc/acpi/battery/BAT0/info')
if _f then
	battmon_string = "batt: %linuxbatt || "
	_f:close()
end

_f=io.open('/sys/bus/acpi/devices/LNXTHERM:00/thermal_zone/temp')
if _f then
	tempmon_string = "CPU temp: %tempinfo_temperature || "
	_f:close()
end

-- Crude way of checking if moc is there
-- but I could not find a better one
_f=io.popen("which mocp")
local _l = _f:read("*a")
_f:close()

if _l ~= "" then
	mocmon_string = " || moc: %mocmon_user"
end

template="[ %date || %itime || load: %load || mem: %meminfo_mem_used/%meminfo_mem_total || " .. battmon_string .. "%df || " .. tempmon_string .. "%uptime || %workspace_pager (%workspace_name) || %bio" .. mocmon_string .. " ] %filler%systray"

-- Create a statusbar
mod_statusbar.create {
    -- First screen, bottom left corner
    screen=0,
    pos='bl',
    -- Set this to true if you want a full-width statusbar
    fullsize=true,
    -- Swallow systray windows
    systray=true,

    -- Template. Tokens %string are replaced with the value of the 
    -- corresponding meter. Currently supported meters are:
    --   date          date
    --   load          load average (1min, 5min, 15min)
    --   load_Nmin     N minute load average (N=1, 5, 15)
    --   mail_new      mail count (mbox format file $MAIL)
    --   mail_unread   mail count
    --   mail_total    mail count
    --   mail_*_new    mail count (from an alternate mail folder, see below)
    --   mail_*_unread mail count
    --   mail_*_total  mail count
    --
    -- Space preceded by % adds stretchable space for alignment of variable
    -- meter value widths. > before meter name aligns right using this 
    -- stretchable space , < left, and | centers.
    -- Meter values may be zero-padded to a width preceding the meter name.
    -- These alignment and padding specifiers and the meter name may be
    -- enclosed in braces {}.
    --
    -- %filler causes things on the marker's sides to be aligned left and
    -- right, respectively, and %systray is a placeholder for system tray
    -- windows and icons.
    --
    template=template,
    --template="[ %date || load:% %>load || mail:% %>mail_new/%>mail_total ] %filler%systray",
    --template="[ %date || load: %05load_1min || mail: %02mail_new/%02mail_total ] %filler%systray",
}


-- Launch ion-statusd. This must be done after creating any statusbars
-- for necessary statusd modules to be parsed from the templates.
mod_statusbar.launch_statusd{
    -- Date meter
    date={
        -- ISO-8601 date format with additional abbreviated day name
        date_format='%a %Y-%m-%d %H:%M',
        -- Finnish etc. date format
        --date_format='%a %d.%m.%Y %H:%M',
        -- Locale date format (usually shows seconds, which would require
        -- updating rather often and can be distracting)
        --date_format='%c',

        -- Additional date formats. 
        --[[ 
        formats={ 
            time = '%H:%M', -- %date_time
        }
        --]]
    },

	-- Internet time
	itime={
	},

	-- Binary clock
--[[
	binclock={
        low_sym = "_",
        empty_sym = ".",
        separator = "|",
        --update_interval=1*1000,
	},
--]]
    -- Load meter
    load={
        --update_interval=10*1000,
        --important_threshold=1.5,
        --critical_threshold=4.0,
    },

    -- Mail meter
    --
    -- To monitor more mbox files, add them to the files table.  For
    -- example, add mail_work_new and mail_junk_new to the template
    -- above, and define them in the files table:
    --
    -- files = { work = "/path/to/work_email", junk = "/path/to/junk" }
    --
    -- Don't use the keyword 'spool' as it's reserved for mbox.
    mail={
        --update_interval=60*1000,
        --mbox=os.getenv("MAIL"),
        --files={},
    },

    meminfo={
		update_interval=10*1000
    },

	tempinfo={
	},

    linuxbatt={
	--update_interval=15*1000,
        bat={1, 0},
        important_threshold=30,
        critical_threshold=10,
    },

	df = {
		fslist = { "/" },
		template = "%mpoint: %used/%size (%usedp)",
		update_interval = 5*1000,
	},

	bio = {
	},

	uptime = {
	},

	workspace = {
	},

	mocmon = {
		interval = 2 * 1000,
		user_format = "%songtitle% - %artist%",
		not_running = "stopped",
		do_monitors = false,
	},
}


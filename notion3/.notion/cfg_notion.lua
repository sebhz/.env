--
-- Ion main configuration file
--
-- This file only includes some settings that are rather frequently altered.
-- The rest of the settings are in cfg_ioncore.lua and individual modules'
-- configuration files (cfg_modulename.lua). 
--
-- When any binding and other customisations that you want are minor, it is 
-- recommended that you include them in a copy of this file in ~/.ion3/.
-- Simply create or copy the relevant settings at the end of this file (from
-- the other files), recalling that a key can be unbound by passing 'nil' 
-- (without the quotes) as the callback. For more information, please see 
-- the Ion configuration manual available from the Ion Web page.
--

-- Set default modifiers. Alt should usually be mapped to Mod1 on
-- XFree86-based systems. The flying window keys are probably Mod3
-- or Mod4; see the output of 'xmodmap'.
local os_meta=os.getenv("NOTION_MOD")
if os_meta == nil then
	os_meta="Mod4"
end
META=os_meta .. "+"
ALTMETA=os_meta .. "+Shift+"

-- Terminal emulator
local os_term=os.getenv("NOTION_TERM")
if os_term == nil then
--	os_term = "xterm -fg darkgrey -bg black -sb -sl 1024"
	os_term = "xterm -bg black -sb -sl 1024 -fn -misc-fixed-medium-r-normal--20-200-75-75-c-100-iso8859-1"
end
XTERM=os_term
-- XTERM="terminator"
-- XTERM="xterm -fg darkgrey -bg black -sb -sl 1024"
-- XTERM="Eterm -O -0 --shade 80 --buttonbar 0 -L 1024"
-- XTERM="gnome-terminal"

-- Some basic settings
ioncore.set{
    -- Maximum delay between clicks in milliseconds to be considered a
    -- double click.
    --dblclick_delay=250,

    -- For keyboard resize, time (in milliseconds) to wait after latest
    -- key press before automatically leaving resize mode (and doing
    -- the resize in case of non-opaque move).
    --kbresize_delay=1500,

    -- Opaque resize?
    --opaque_resize=false,

    -- Movement commands warp the pointer to frames instead of just
    -- changing focus. Enabled by default.
    --warp=true,

    -- Switch frames to display newly mapped windows
    switchto=true,

    -- Default index for windows in frames: one of 'last', 'next' (for
    -- after current), or 'next-act' (for after current and anything with
    -- activity right after it).
    --frame_default_index='next',
	framed_transients=true,

    -- Auto-unsqueeze transients/menus/queries.
    --unsqueeze=true,

    -- Display notification tooltips for activity on hidden workspace.
    --screen_notify=true,
}


-- Load default settings. The file cfg_defaults loads all the files
-- commented out below, except mod_dock. If you do not want to load
-- something, comment out this line, and uncomment the lines corresponding
-- the the modules or configuration files that you want, below.
-- The modules' configuration files correspond to the names of the 
-- modules with 'mod' replaced by 'cfg'.
-- dopath("cfg_defaults")

-- Load configuration of the Ion 'core'. Most bindings are here.
dopath("cfg_notioncore")

-- Load some kludges to make apps behave better.
dopath("cfg_kludges")

-- Define some layouts. 
dopath("cfg_layouts")

-- Load some modules. Bindings and other configuration specific to modules
-- are in the files cfg_modulename.lua.
dopath("mod_query")
dopath("mod_menu")
dopath("mod_tiling")
dopath("mod_statusbar")
-- dopath("mod_dock")
dopath("mod_sp")
dopath("mod_notionflux")
-- dopath("local.lua")

--
-- Common customisations
--

-- Uncommenting the following lines should get you plain-old-menus instead
-- of query-menus.
--[[
defbindings("WScreen", {
    kpress(META.."F12", "mod_menu.menu(_, _sub, 'mainmenu', {big=true})"),
})
]]--
defbindings("WMPlex.toplevel", {
    kpress(META.."M", "mod_menu.menu(_, _sub, 'ctxmenu')"),
})

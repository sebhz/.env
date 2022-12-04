#!/bin/bash
#set -x

[[ -f "${HOME}/.screenlayout/default.sh" ]] && "${HOME}/.screenlayout/default.sh"
[[ -f "/usr/bin/compton" ]] && compton &

# xscreensaver will be launched as part of xdg autostart
# Start XDG autostart .desktop files using dex. See also
# https://wiki.archlinux.org/index.php/XDG_Autostart
dex --autostart --environment dwm

# disable CapsLock - obsoleted by interception-tools
# setxkbmap -option caps:none

# Background...
if [[ -e "${HOME}/.fehbg" ]]; then
    "${HOME}/.fehbg" &
else
    xsetroot -grey
fi

if [ -e /usr/local/bin/dwm ]; then
    # Tell AWT toolkit we are a non reparenting WM
    declare -rx _JAVA_AWT_WM_NONREPARENTING=1

    # Stuff for statusbar
    [[ -f "${HOME}/bin/pulse_monitor" ]] &&  { "${HOME}/bin/pulse_monitor" & }
    [[ -f "${HOME}/bin/dwmblocks" ]] && { "${HOME}/bin/dwmblocks" & }

    # Launch WM
    exec /usr/local/bin/dwm
elif [ -e /usr/bin/i3 ]; then
    exec /usr/bin/i3
else
    exec xterm
fi


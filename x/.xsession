#!/bin/bash
#set -x

[[ -x "${HOME}/.screenlayout/default.sh" ]] && "${HOME}/.screenlayout/default.sh"
[[ -n "$(which compton)" ]] &&  { compton & }

# xscreensaver will be launched as part of xdg autostart
# Start XDG autostart .desktop files using dex. See also
# https://wiki.archlinux.org/index.php/XDG_Autostart
dex --autostart --environment dwm

# disable CapsLock - obsoleted by interception-tools
# setxkbmap -option caps:none

# Background...
if [[ -x "${HOME}/.fehbg" ]]; then
    "${HOME}/.fehbg" &
else
    xsetroot -grey
fi

if [[ -n "$(which dwm)" ]]; then
    # Tell AWT toolkit we are a non reparenting WM
    declare -rx _JAVA_AWT_WM_NONREPARENTING=1

    # Stuff for statusbar
    [[ -x "${HOME}/bin/pulse_monitor" ]] &&  { "${HOME}/bin/pulse_monitor" & }
    [[ -x "${HOME}/bin/dwmblocks" ]] && { "${HOME}/bin/dwmblocks" & }

    # Launch WM
    exec dwm
elif [[ -n "$(which i3)" ]]; then
    exec i3
else
    exec xterm
fi


#!/bin/bash
set -x

if [ -f ${HOME}/.screenlayout/default.sh ] ; then
    ${HOME}/.screenlayout/default.sh
fi

if [ -f /usr/bin/compton ]; then
    compton &
fi

# xscreensaver will be launched as part of xdg autostart
# Start XDG autostart .desktop files using dex. See also
# https://wiki.archlinux.org/index.php/XDG_Autostart
dex --autostart --environment dwm

# disable CapsLock
setxkbmap -option caps:none

# Background...
if [ -e "${HOME}/.fehbg" ]; then
    "${HOME}/.fehbg" &
else
    xsetroot -grey
fi

if [ -e /usr/local/bin/dwm ]; then
    # Tell AWT toolkit we are a non reparenting WM
    export _JAVA_AWT_WM_NONREPARENTING=1

    # Stuff for statusbar
    if [ -f ${HOME}/bin/pulse_monitor ] ; then
        ${HOME}/bin/pulse_monitor &
    fi
    if [ -f ${HOME}/bin/dwmblocks ] ; then
        ${HOME}/bin/dwmblocks &
    fi

    # Launch WM
    exec /usr/local/bin/dwm
elif [ -e /usr/bin/i3 ]; then
    exec /usr/bin/i3
else
    exec xterm
fi


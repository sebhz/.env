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
dex --autostart --environment i3

# disable CapsLock
setxkbmap -option caps:none

# Background...
if [ -e "${HOME}/.fehbg" ]; then
    "${HOME}/.fehbg" &
else
    xsetroot -grey
fi

if [ -e /usr/bin/i3 ]; then
    exec /usr/bin/i3
elif [ -e /usr/local/bin/dwm ]; then
    # Tell AWT toolkit we are a non reparenting WM
    export _JAVA_AWT_WM_NONREPARENTING=1
    if [ -f ${HOME}/bin/dwmstatus.sh ] ; then
        ${HOME}/bin/dwmstatus.sh &
    fi
    exec /usr/local/bin/dwm
else
    exec xterm
fi


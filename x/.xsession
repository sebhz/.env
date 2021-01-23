#!/bin/bash
set -ex

if [ -f ${HOME}/.screenlayout/default.sh ] ; then
    ${HOME}/.screenlayout/default.sh
fi

if [ -f /usr/bin/compton ]; then
    compton &
fi

if [ -e /usr/bin/xscreensaver ]; then
    /usr/bin/xscreensaver -nosplash &
fi

# Remap CapsLock to Escape
setxkbmap -option caps:escape

if [ -e /usr/local/bin/dwm ]; then
    # Tell AWT toolkit we are a non reparenting WM
    export _JAVA_AWT_WM_NONREPARENTING=1
    # To get nice floating window movements we need something in the root window
    if [ -e ${HOME}/.fehbg ]; then
        ${HOME}/.fehbg &
    else
        xsetroot -grey
    fi
    if [ -f ${HOME}/bin/dwmstatus.sh ] ; then
        ${HOME}/bin/dwmstatus.sh &
    fi
    exec /usr/local/bin/dwm
elif [ -e /usr/bin/notion ]; then
    exec /usr/bin/notion
else
    exec xterm
fi


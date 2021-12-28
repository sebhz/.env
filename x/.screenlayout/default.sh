#!/bin/sh

# Is my external monitor not disconnected ?
xrandr | grep HDMI-1 | grep disconnected

if [ $? = 0 ]; then
    exit
fi

xrandr --output eDP-1 --off --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal


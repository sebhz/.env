#!/bin/bash
set -x

# Is my external monitor connected
wlr-randr | grep HDMI-A-1

if [[ $? != 0 ]]; then
  exit
fi

wlr-randr --output eDP-1 --off --output HDMI-A-1 --pos 0,0

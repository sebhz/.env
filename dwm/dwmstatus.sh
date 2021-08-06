#!/bin/bash

get_tw() {
    MON_TW=$(timew status)
}

# Sun altitude and azimuth
get_sun() {
    local lp="/opt/astro/meeus/bash"
    MON_SUN=$(ASTRO_SH_LIB_PATH=${lp}/lib ${lp}/prg/sun_coord.sh 43.56 -7.12)
}

get_cmus() {
    _cmus_sts=$(cmus-remote -Q 2>&1 | grep status | cut -d' ' -f2)

    if [ "${_cmus_sts}" == "stopped" ]; then
        MON_CMUS='x'
    elif [ "${_cmus_sts}" == "paused" ]; then
        MON_CMUS='|'
    elif [ "${_cmus_sts}" == "playing" ]; then
        MON_CMUS='>'
    else
        MON_CMUS="-"
    fi
}

# Num lock (my keyboard has no LED)
get_mods() {
    MON_MODS=$(xset q | grep Caps | tr -s ' ' | cut -d ' ' -f 9 | sed 's/on/▣/g' | sed 's/off/▢/g')
}

# Dropbox daemon status... kind of
get_dropbox() {
    if [ -e "/usr/bin/dropbox" ]; then
        /usr/bin/dropbox running
        if [ "$?" -eq 1 ]; then
            _st=$(/usr/bin/dropbox status)
            # One day I'll look into this locale problem
            if [ "${_st}" == "À jour" ] || [ "${_st}" == "Up to date" ]; then
                MON_DROPBOX="U"
            else
                MON_DROPBOX="W"
            fi
        else
            MON_DROPBOX="X"
        fi
    else
        MON_DROPBOX="-"
    fi
}

# Processor or package temp. Heavily dependent on machine
get_temp() {
    _pkg=$1
    _temp="-"

    if [ -e /usr/bin/sensors ]; then
        _temp=$(sensors | grep temp1 | sed -e 's/ \+/ /g' | cut -d' ' -f2)
    else
        # Try and do our best from sysfs (for some reason those sometimes change)
        if [ -e /sys/class/thermal/thermal_zone${_pkg}/temp ]; then
            _temp=$(($(cat /sys/class/thermal/thermal_zone${_pkg}/temp)/1000))℃
        fi
    fi
    MON_TEMP=${_temp}
}

# Volume
get_volu() {
    _v=$(dwm-audio-wrapper gv)

    if [ "$_v" != "" ]; then
        MON_VOL="${_v}% ($(dwm-audio-wrapper sk))"
    else
        MON_VOL="x"
    fi
}

# Date and time
get_date() {
    MON_DATE="$(date '+%d/%m %H:%M')"
    # With week number
    #MON_DATE="$(date '+%d/%m %H:%M (%V)')"
}

# Battery level. Also dependent on machine
get_batt() {
    _low_limit=$1
    _cap="$(cat /sys/class/power_supply/BAT0/capacity)"
    _sts="$(cat /sys/class/power_supply/BAT0/status)"

    if [ "$_sts" = "Charging" ]; then
        _st="+"
    elif [ "$_sts" = "Discharging" ]; then
        if [ $_cap -lt $_low_limit ]; then
            _st="!"
        else
            _st="-"
        fi
    elif [ "$_sts" = "Full" ]; then
        _st="="
    else
        _st="?"
    fi
    MON_BAT="$_cap%$_st"
}

# Load average. See
get_load() {
    MON_LOADAVG="$(cut -d' ' -f1-3 /proc/loadavg)"
}

# Network up/downlink volume transferred
get_netw() {
    if=$1
    MON_NETW="-"

    if [ -e /sys/class/net/${if}/statistics ]; then
        _rxmib=$(bc <<< "scale=2; $(cat /sys/class/net/${if}/statistics/rx_bytes)/1024/1024")
        _txmib=$(bc <<< "scale=2; $(cat /sys/class/net/${if}/statistics/tx_bytes)/1024/1024")
        MON_NETW="$if: ${_rxmib}|${_txmib}⇵ MiB"
    fi
}

# Modify variables here
# Network interface
CFG_NETIF=wlo1
# Battery low level (%) for alert display
CFG_BAT_LO=15
# Thermal zone number for CPU in case sensors is not installed
CFG_THZ=1

while true; do
#    get_tw
    get_temp ${CFG_THZ}
    get_batt ${CFG_BAT_LO}
    get_volu
    get_date
    get_load
    get_netw ${CFG_NETIF}
    get_dropbox
    get_mods
    get_cmus
    get_sun

    MON_STR="[$MON_CMUS] [$MON_MODS] [$MON_DROPBOX] [$MON_NETW] [vol: $MON_VOL] [load: $MON_LOADAVG] [temp:$MON_TEMP] [bat: $MON_BAT] [$MON_DATE] [$MON_SUN]"
    if [ -n "${MON_DEBUG+x}" ]
    then
        echo "$MON_STR"
        break
    else
        xsetroot -name "$MON_STR"
    fi
    sleep 5
done

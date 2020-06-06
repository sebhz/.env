#!/bin/bash

get_mods() {
    MODS="CN: "$(xset q | grep Caps | tr -s ' ' | cut -d ' ' -f 5,9 | sed 's/on/▣/g' | sed 's/off/▢/g')
}

get_dropbox() {
    if [ -e "/usr/bin/dropbox" ]; then
        /usr/bin/dropbox running
        if [ "$?" -eq 1 ]; then
            _st=$(/usr/bin/dropbox status)
            if [ "${_st}" == "Up to date" ]; then
                DROPBOX="U"
            else
                DROPBOX="W"
            fi
        else
            DROPBOX="X"
        fi
    else
        DROPBOX="-"
    fi
}

get_temp() {
    TEMP=""
    for i in $(seq 0 1); do
        TEMP=${TEMP}" $(($(cat /sys/class/thermal/thermal_zone$i/temp)/1000))℃"
    done
    TEMP=${TEMP}
}

get_volu() {
    VOL="$(amixer -c$1 sget Master | grep -Eo '[0-9]+%')"
}

get_date() {
    DATE="$(date '+%d/%m %H:%M')"
}

get_batt() {
    _low_limit=15

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
    BAT="$_cap%$_st"
}

get_load() {
    LOADAVG="$(cut -d' ' -f1-3 /proc/loadavg)"
}

get_netw() {
    if=$1

    _rxmib=$(bc <<< "scale=2; $(cat /sys/class/net/${if}/statistics/rx_bytes)/1024/1024")
    _txmib=$(bc <<< "scale=2; $(cat /sys/class/net/${if}/statistics/tx_bytes)/1024/1024")

    NETW="$if: ${_rxmib}|${_txmib}⇵ MiB"
}

while true; do
    get_temp
    get_batt
    get_volu 1
    get_date
    get_load
    get_netw wlo1
    get_dropbox
    get_mods

    xsetroot -name "[$MODS] [$DROPBOX] [$NETW] [vol: $VOL] [load: $LOADAVG] [temp:$TEMP] [bat: $BAT] [$DATE]"
    sleep 5
done

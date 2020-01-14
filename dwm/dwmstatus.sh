#!/bin/sh

get_temp() {
    TEMP=""
    for i in $(seq 0 $(($(nproc)-1))); do
        TEMP=${TEMP}" $(($(cat /sys/class/thermal/thermal_zone$i/temp)/1000))℃"
    done
    TEMP=${TEMP}
}

get_volu() {
    VOL="$(amixer -c0 sget Master | grep -Eo '[0-9]+%')"
}

get_date() {
    DATE="$(date '+%d/%m %H:%M (WW%V)')"
}

get_batt() {
    _cap="$(cat /sys/class/power_supply/BAT0/capacity)"
    _sts="$(cat /sys/class/power_supply/BAT0/status)"

    if [ "$_sts" = "Charging" ]; then
        _st="+"
    elif [ "$_sts" = "Discharging" ]; then
        _st="-"
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
    get_volu
    get_date
    get_load
    get_netw enp0s25

    xsetroot -name "[$NETW] [load: $LOADAVG] [temp:$TEMP] [bat: $BAT] [vol: $VOL] [$DATE]"
    sleep 5
done

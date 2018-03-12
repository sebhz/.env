#!/bin/bash

# Displays local duodecimal time
# See https://en.wikipedia.org/wiki/Duodecimal
ttime=$(echo "\
hour=$(date +%H);
min=$(date +%M);
sec=$(date +%S);
seconds=3600*hour+60*min+sec 

obase=12;
print seconds/7200, (seconds%7200)/600, (seconds%600)/50, \".\", (seconds%50)*144/50
"\
|bc)

echo $ttime


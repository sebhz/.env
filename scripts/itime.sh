#!/bin/bash

# Displays Internet Time.
# See https://en.wikipedia.org/wiki/Swatch_Internet_Time
echo "\
scale=0;
v=($(date +%s)+3600)%86400;
scale=2;
v/86.4
"\
|bc

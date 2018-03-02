#!/bin/bash

# Displays French Decimal Time
# See https://en.wikipedia.org/wiki/Decimal_Time
echo "\
v=$(date +%s)%86400;
scale=4;
v/8640
"\
|bc

#!/bin/bash

QXX=s24

TEAMS=(s24-4pm-1 s24-4pm-2 s24-4pm-3 s24-4pm-4 s24-4pm-5 s24-4pm-6 s24-4pm-7 s24-4pm-8 s24-5pm-1 s24-5pm-2 s24-5pm-3 s24-5pm-4 s24-5pm-5 s24-5pm-6 s24-5pm-7 s24-5pm-8)
DOKKUS=( 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16)

if [ ${#TEAMS[@]} != ${#DOKKUS[@]} ] ; then
    echo "Error: length of TEAMS and DOKKUS must match"
    exit 0
fi

COURSES_TEAMS="s24-4pm-1 s24-4pm-2 s24-4pm-3 s24-4pm-4"
HAPPYCOWS_TEAMS="s24-4pm-5 s24-4pm-6 s24-4pm-7 s24-4pm-8"
ORGANIC_TEAMS="s24-5pm-1 s24-5pm-2 s24-5pm-3 s24-5pm-4"
GAUCHORIDE_TEAMS="s24-5pm-5 s24-5pm-6 s24-5pm-7 s24-5pm-8"







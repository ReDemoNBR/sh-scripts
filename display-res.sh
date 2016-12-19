#!/bin/bash

# Force change VGA monitor resolution and disables other monitors
#
# To use:
# 	-sh /path/to/this/script/display-res.sh "1920x1080"
#	-replace "1920x1080" for your desirable resolution

w=$(echo $(echo $1 | cut -f 1 -d "x"))
h=$(echo $(echo $1 | cut -f 2 -d "x"))
mode=$(echo '"'$(echo $(echo $(cvt $w $h) | cut -f 2,3 -d '"')))
res=$(echo $mode | cut -d '"' -f 2)
clock=$(echo ${mode//\"$res\"} | cut -f 1 -d " ")
width=${mode//\"$res\" $clock }
width="${width% $h*}"
height=${mode//\"$res\" $clock $width }
xrandr --newmode $res  $clock  $width  $height
xrandr --addmode VGA1 $res
xrandr --output DisplayPort-0 --off --output VGA1 --mode $res --pos 0x0 --rotate normal --output HDMI-0 --off

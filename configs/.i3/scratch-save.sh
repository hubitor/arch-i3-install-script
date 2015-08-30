#!/usr/bin/env sh

key=$1
id=`xdotool getwindowfocus`

echo $id > $key
i3-msg "[id=$id]" move scratchpad

#!/usr/bin/env sh

key=$1

id=`cat $key`

i3-msg "[id=$id]" scratchpad show

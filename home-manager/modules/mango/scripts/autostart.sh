#!/usr/bin/env bash

# Start the wallpaper daemon
@swaybg@ -i "@wallpaper@" -m fill &

# Start Noctalia bar & shell
sleep 1 && @noctalia@ &

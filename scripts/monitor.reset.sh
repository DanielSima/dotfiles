#!/bin/bash

multi(){
    xrandr --output eDP-1 --off
    xrandr --output DP-1 --mode 1920x1080 --primary
    xrandr --output HDMI-1 --mode 1920x1080 --left-of DP-1
}

single(){
    xrandr --output eDP-1 --mode 1920x1080 --primary
}

if xrandr --listmonitors | grep "HDMI" > /dev/null 2>&1; then
    multi
else
    single
fi

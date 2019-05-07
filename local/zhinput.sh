#!/bin/bash

chars=$(zenity --title 中文输入 --text 中文输入 --width 500 --entry 2>/dev/null)
sleep 0.1
xdotool key --delay 150 Escape t
sleep 0.2
xdotool type --delay 150 "$chars"
xdotool key Return

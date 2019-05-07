#!/bin/bash
# toggle second display status [ use xrandr ]
# reference: https://wiki.archlinux.org/index.php/Xrandr
# tested with: xrandr 1.5.0
# date: 2018-03-19 17:26:58

# =========================================
# unnecessary for other wm
_AWESOME_PID=`pgrep -U $UID awesome`
if [ ! "$_AWESOME_PID" ]; then
  echo "current wm is not awesome"
  exit 0
fi
# =========================================

_OUTPUTS=$(xrandr | grep -E ' connected' | cut -f 1 -d ' ')
_DEFAULT_OUTPUT=$(xrandr | grep primary | cut -f 1 -d ' ')
_COMMAND=""
for _CUR in $_OUTPUTS; do
  if [ "$_CUR" != "$_DEFAULT_OUTPUT" ]; then
    _OFF=`xrandr | grep "$_CUR connected ("`
    if [ "$_OFF" != "" ]; then
      _COMMAND="xrandr --output $_CUR --above $_DEFAULT_OUTPUT --auto"
    else
      _COMMAND="xrandr --output $_CUR --off"
    fi
    printf "$_COMMAND (Y/n): "
    read _RESULT
    if [ "$_RESULT" != "" ]; then
      if [ "$_RESULT" != "Y" ]; then
        echo "abort!"
        exit 0
      fi
    fi
    $_COMMAND
    exit 0
  fi
done
echo "not found other display"

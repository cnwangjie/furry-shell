#!/bin/bash
# take a screenshot

_SCRIPT_NAME=`basename $0`
_REQUIRED_CMDS=(xclip scrot)
_SELECT_RANGE=`echo $@ | grep -e "-\w*s"` # -s
_COPY_TO_CLIPBOARD=`echo $@ | grep -e "-\w*c"` # -c
_QUIET=`echo $@ | grep -e "-\w*q"` # -q

function _command_exists () {
  command -v "$1" >/dev/null 2>&1
}

for _CMD in ${_REQUIRED_CMDS[@]}; do
  if ! _command_exists $_CMD; then
    notify-send -u critical "<b>$_SCRIPT_NAME</b> need command <b>$_CMD</b>" -t 3000
    exit 1
  fi
done

_CMD="scrot -d 0.2"
if [ $_SELECT_RANGE ]; then
  _CMD="$_CMD -s"
fi
_CMD="$_CMD -e 'echo \$f'"

sleep 0.5
_FILE_NAME=`eval "$_CMD"`

if [ $_COPY_TO_CLIPBOARD ]; then
  xclip -selection clipboard -t image/png -i $_FILE_NAME
  rm $_FILE_NAME
  if [ ! $_QUIET ]; then
    notify-send "screenshot saved to clipboard" -t 3000
  fi
else
  mv $_FILE_NAME $HOME/Pictures
  _PATH="$HOME/Pictures/$_FILE_NAME"
  if [ ! $_QUIET ]; then
    notify-send "screenshot saved to <b>$_PATH</b>" -t 3000
  fi
fi

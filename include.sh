#!/bin/bash
# date: 2019-10-07
# include all vendor & some utility functions

. "`dirname $0`/vendor/relpath.sh"

function _to_lower() {
  echo ${@:1} | tr '[:upper:]' '[:lower:]'
}

function _in_list() {
  if [ $# -lt 2 ]; then
    echo "_in_list must has at least two arguments"
    exit -1
  fi

  local item
  for item in "${@:2}"; do
    if [ "$item" = "$1" ]; then
      return 0
    fi
  done

  return 1
}

function _sure_to_continue() {
  local cond=$1

  if [ "$cond" = "" ]; then
    cond="y"
  fi

  local c
  read c
  if [ "`_to_lower $c`" != "$cond" ]; then
    echo "abort!"
    exit 0
  fi
}

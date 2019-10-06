#!/bin/bash

_DATE=2019-10-07
_USAGE="install.sh $_DATE
Create soft link for scripts to user's binary directory.

Usage: install.sh [command]
"

_DIRNAME=`dirname $0`
_DIRNAME=`cd "$_DIRNAME" && pwd`
_INSTALL_PATH=/usr/local/bin
_INSTALL_TARGET="$_DIRNAME/local/*"

if [ "uninstall" = "$1" ]; then
  _COMMAND="uninstall"
else
  _COMMAND="install"
fi

. "$_DIRNAME/include.sh"

if [ "install" = "$_COMMAND" ]; then
  _PATH=`echo $PATH | tr ':' ' '`

  if ! _in_list "$_INSTALL_PATH" $_PATH; then
    echo "$_INSTALL_PATH not in \$PATH, sure to continue? (y,N)"
    _sure_to_continue
  fi

  for TARGET in $_INSTALL_TARGET; do
    _FILENAME=`basename $TARGET`
    _TARGET="`dirname "$TARGET"`/$_FILENAME"
    _FINAL_INSTALL_PATH="$_INSTALL_PATH/$_FILENAME"
    _RELATIVE_PATH=`relpath $_INSTALL_PATH $_TARGET`
    if [ ! -f "$_FINAL_INSTALL_PATH" ]; then
      ln -s "$_RELATIVE_PATH" "$_FINAL_INSTALL_PATH"
      echo "✅ create $_FINAL_INSTALL_PATH -> $_RELATIVE_PATH"
    elif [[ "$_FINAL_INSTALL_PATH" -ef "$_TARGET" ]]; then
      echo "✅ exists $_FINAL_INSTALL_PATH"
    else
      echo "❌ exists $_FINAL_INSTALL_PATH already exist"
    fi
  done

elif [ "uninstall" = "$_COMMAND" ]; then
  for TARGET in $_INSTALL_TARGET; do
    _FILENAME=`basename $TARGET`
    _FINAL_INSTALL_PATH="$_INSTALL_PATH/$_FILENAME"
    if [ ! -f "$_FINAL_INSTALL_PATH" ]; then
      echo "✅ not exist $_FINAL_INSTALL_PATH"
    elif [[ "$_FINAL_INSTALL_PATH" -ef "$TARGET" ]]; then
      rm "$_FINAL_INSTALL_PATH"
      echo "✅ remove $_FINAL_INSTALL_PATH"
    else
      echo "❌ $_FINAL_INSTALL_PATH is not a symbolic link to $TARGET"
    fi
  done
fi



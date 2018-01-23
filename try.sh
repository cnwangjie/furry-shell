#!/bin/bash

# temp directory path
TEMPDIR="~/Workspace/tmp"

# default editor
EDITOR="code"

# filename template
# if FULL_NAME not assigned will auto generate a file with this template
# `#N` is increased number
TEMPLATE="t#N"

USAGE="try.sh (2018-01-24)
Create a test file in temp directory and use editor to open it then to test your
nice idea.

Usage: try.sh SUFFIX [EDITOR]     auto create a file with unused filename
   or: try.sh FULL_NAME [EDITOR]  assign filename

example: try.sh js vim
         try.sh StdArrayTest.cc vim
"

if [ "" = "$1" ]; then
  echo "$USAGE"
  exit 0
fi

SUFFIX="$1"
if [[ "$SUFFIX" =~ "." ]]; then
  FULL_NAME="$SUFFIX"
  SUFFIX=`echo "$SUFFIX" | awk -F "." '{print $NF}'`
fi
TEMPDIR=`eval "echo "$TEMPDIR/$SUFFIX" "`
if [ ! -e "$TEMPDIR" ]; then
  mkdir -p "$TEMPDIR"
fi
FILE_NAME_RE=`echo "$TEMPLATE" | sed "s/#N/[0-9]+/"`
NUMBER=`ls "$TEMPDIR" | grep -E "$FILE_NAME_RE" -o | grep -E "[0-9]+" -o | sort -n | tail -1`
if [ "" = "$NUMBER" ]; then
  NUMBER=0
else
  let NUMBER+=1
fi

if [ "" = "$FULL_NAME" ]; then
  FULL_NAME=`echo "$TEMPLATE" | sed "s/#N/$NUMBER/"`
  FULL_NAME="$FULL_NAME.$SUFFIX"
fi
FULL_PATH="$TEMPDIR/$FULL_NAME"
touch "$FULL_PATH"
if [ "" != "$2" ]; then
  EDITOR="$2"
fi
echo "$EDITOR $FULL_PATH"
exec "$EDITOR" "$FULL_PATH"




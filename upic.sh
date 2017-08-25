#!/bin/bash

filename=$(ls -t $HOME/Pictures | head -n 1)
filepath="$HOME/Pictures/$filename"
lastuploadpath="$HOME/.lastupload"

if [ ! -d "$lastuploadpath" ];then
  touch $lastuploadpath
fi

lastuploadfile=$(cat "${lastuploadpath}")

if [ "$filepath" = "$lastuploadfile" ];then
  echo "have uploaded!"
else
  curl -F "smfile=@$filepath" -F "format=xml" https://sm.ms/api/upload | grep -Po 'https://[a-z0-9./]+.[a-z]+' | curl -X PUT -F c=@- http://fars.ee/a43bc24e-1250-406b-aa3d-890db4739fc7 && echo "/home/${user}/Pictures/${filename}" > ${lastuploadpath}
fi

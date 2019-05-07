#!/bin/bash

filename=$(ls -t $HOME/Pictures | head -n 1)
filepath="$HOME/Pictures/$filename"
lastuploadpath="$HOME/.lastupload"

if [ ! -d "$lastuploadpath" ];then
  touch $lastuploadpath
fi

lastuploadfile=$(cat "${lastuploadpath}")
echo "$filepath"
if [ "$filepath" = "$lastuploadfile" ];then
  echo "have uploaded!"
else
  imageurl=`curl -F "smfile=@$filepath" -F "format=xml" https://sm.ms/api/upload | grep -Po 'https://[a-z0-9./]+.[a-z]+'`
  echo "$imageurl"
  curl -X PUT -F c="$imageurl" http://fars.ee/929938aa-c95f-42ff-a685-ceddcd5f6e96 && echo "/home/${user}/Pictures/${filename}" > ${lastuploadpath}
fi

#!/bin/bash

user=$(whoami)
filename=$(ls -t /home/${user}/Pictures | head -n 1)
curl -F "smfile=@/home/${user}/Pictures/${filename}" -F "format=xml" https://sm.ms/api/upload | grep -Po 'https://[a-z0-9./]+.png' | curl -X PUT -F c=@- http://fars.ee/a43bc24e-1250-406b-aa3d-890db4739fc7
#!/bin/bash
# I need help in a new system
# Tell me what awesome method we have

this=$0
mtime=$(stat ${this} | grep -i modify | awk '{print $2}')
doc="
           \033[1;37m-= HOW TO USE THE AWESOME SYSTEM OF WANG JIE =-\033[0m

\033[1;37m 1. SHORTCUT \033[0m
  - \033[36mCtrl+A\033[0m to the start of terminal input
  - \033[36mCtrl+E\033[0m to the end of terminal input
  - \033[36mCtrl+U\033[0m clear terminal input
  - \033[36mCtrl+L\033[0m clear terminal output
  - \033[36m!!\033[0m last command
  - \033[36m!$\033[0m last parameter of last command

\033[1;37m 2. SOFTWARE \033[0m
  - \033[36mydcv\033[0m translate word between English and Chinese
  - \033[36mmycli\033[0m a mysql client with highlight
  - \033[36mhtop\033[0m better than top
  - \033[36myou-get\033[0m download video from YouTube / Youku / Niconico etc.
  - \033[36mtig\033[0m replace git diff
  - \033[36mhttp\033[0m curl for humans
  - \033[36maria2c\033[0m tool for download file from pan.baidu.com

\033[1;37m 3. IMPORTANT TOOL \033[0m
  - \033[36mmv SRC DST\033[0m move and rename file
  - \033[36mln -s TARGET LINK_NAME\033[0m create soft link
  - \033[36mfind / -name FILE_NAME\033[0m search file

\033[1;37m 4. EXTRA \033[0m

lastest modified: ${mtime}
"
echo -e "${doc}" | less

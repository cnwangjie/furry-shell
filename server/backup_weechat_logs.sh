#!/bin/bash
# for weechat host
# date: 2019.5.8

# !!! please set env _NOTIFY_TARGET

_TAR_FILE=/home/weechat/logs.tar.gz
_START=`date +%s`

# compress logs
tar -zcvf $_TAR_FILE /home/weechat/.weechat/logs

_SIZE=`du -h $_TAR_FILE | cut -f 1`

# save to nutstore
rclone copy $_TAR_FILE nutstore:backup/weechat -P

_END=`date +%s`
let _TIME_SPENT=$_END-$_START
_MSG="*Weechat logs backup completed*\n• file size: $_SIZE (after gzip)\n• time spent: ${_TIME_SPENT}s"
_JSON="{\"value1\":\"$_MSG\"}"

# send notification to slack
curl -X POST -H "Content-Type: application/json" -d "$_JSON" $_NOTIFY_TARGET


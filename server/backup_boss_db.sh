#!/bin/bash
# for boss host
# date: 2019.5.8

# !!! please set env _NOTIFY_TARGET

_TAR_FILE=/root/do-boss-db.tar.gz
_START=`date +%s`

# count number of users & dump db
_SCRIPT_IN_CONTAINER=" \
mongo --host mongo:27017 --eval \"db = db.getSiblingDB('boss'); db.users.count()\" | tail -n 1 | tee /backup/users_count; \
mongodump --out /backup/mongo --host mongo:27017; \
"
docker run --rm --link dao_mongo_1:mongo -v /backup:/backup mongo bash -c "$_SCRIPT_IN_CONTAINER"

# compress backup files
tar -zcvf $_TAR_FILE /backup/mongo

_USERS_COUNT=`cat /backup/users_count`
_SIZE=`du -h $_TAR_FILE | cut -f 1`

# save to gdrive
rclone copy $_TAR_FILE gd:backup -P

_END=`date +%s`
let _TIME_SPENT=$_END-$_START
_MSG="*boss db backup completed*\n• users: $_USERS_COUNT\n • file size: $_SIZE (after gzip)\n• time spent: ${_TIME_SPENT}s"
_JSON="{\"value1\":\"$_MSG\",\"value2\":\"$_TITLE\"}"
curl -X POST -H "Content-Type: application/json" -d "$_JSON" $_NOTIFY_TARGET

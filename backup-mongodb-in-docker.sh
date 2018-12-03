#!/bin/bash

usage() {
  local _NAME=`basename $0`
  echo ""
  echo "$_NAME 2018-12-03"
  echo ""
  echo "Usage: $_NAME [output path] [mongodb container name] [mongodb image name] [host]"
  echo ""
  echo "Run '$_NAME' -h to show help message"
  exit 0
}

if [ "$1" = "-h" ]; then
  usage
fi

if [ "$1" = "" ]; then
  _OUTPUT_PATH=`pwd`
else
  _OUTPUT_PATH="$1"
fi

if [ "$2" = "" ]; then
  _CONTAINER=`docker ps -f status=running --format "{{.Names}}" | grep mongo | head -n 1`
  if [ "$_CONTAINER" = "" ]; then
    echo "Cannot find a running mongodb container"
    usage
  fi
else
  _CONTAINER="$2"
fi

if [ "$3" = "" ]; then
  _IMAGE=`docker images mongo --format "{{.Repository}}:{{.Tag}}" | head -n 1`
  if [ "$_IMAGE" = "" ]; then
    echo "Cannot find a mongodb image"
    usage
  fi
else
  _IMAGE="$3"
fi

if [ "$4" = "" ]; then
  _HOST="mongo:27017"
else
  _HOST="$4"
fi

docker run --rm --link $_CONTAINER -v $_OUTPUT_PATH:/backup $_IMAGE  bash -c "mongodump --out /backup --host $_HOST"

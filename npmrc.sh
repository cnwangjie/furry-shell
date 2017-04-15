#!/bin/bash
# 让npm的镜像从官方源和淘宝源之间切换
now=`npm config get registry`
ori="https://registry.npmjs.com/"
tby="https://registry.npm.taobao.org"
if [ "$now" = "$ori" ];then
  npm config set registry ${tby}
  echo "npm registry has checkout to ${tby}"
else
  npm config set registry ${ori}
  echo "npm registry has checkout to ${ori}"
fi

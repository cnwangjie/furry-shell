#!/bin/bash

# Tested in Debian
clear

_NO_INTERACTION=`echo $@ | grep -e "-\w*y"`

function _command_exist () {
  command -v $1 >/dev/null 2>&1
}

if ! _command_exist wget; then
  echo "Please install wget first"
  read
  exit 1
fi

function _install_node () {
  if _command_exist node; then
    echo "mongodb is installed in your system"
    return
  fi
  NODE_VERSION=`echo "$(wget https://nodejs.org/dist/index.json -O -)" | jq '.[0].version' | grep -o -e '[^"]*'`
  wget https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-x64.tar.xz
  tar -xvJf node-$NODE_VERSION-linux-x64.tar.xz
  mv node-$NODE_VERSION-linux-x64 /usr/local/node
  rm /bin/node /bin/npm
  ln -s /usr/local/node/bin/node /bin/node
  ln -s /usr/local/node/bin/npm /bin/npm
}

function _install_mongodb () {
  if _command_exist mongod; then
    echo "mongodb is installed in your system"
    return
  fi
  wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.4.7.tgz
  tar -zxvf mongodb-linux-x86_64-3.4.7.tgz
  mkdir -p mongodb
  cp -R -n mongodb-linux-x86_64-3.4.7/ mongodb
  echo "export PATH=`pwd`/mongodb/bin:\$PATH" >> .bashrc
  mkdir -p /data/db
}

_install_redis () {
  if _command_exist node; then
    echo "mongodb is installed in your system"
    return
  fi
  wget http://download.redis.io/releases/redis-stable.tar.gz
  tar -xvf redis-stable.tar.gz
  mv redis-stable redis
  cd redis
  make distclean
  make
  cd utils
  ./install_server.sh
  cd ..
  cd ..
}
if [ $_NO_INTERACTION ]; then
  _INSTALL_NODE=yes
  _INSTALL_REDIS=yes
  _INSTALL_MONGODB=yes
else
  clear
  echo "Install node.js ? (yes / no)"
  read _INSTALL_NODE
  echo "Install mongodb ? (yes / no)"
  read _INSTALL_MONGODB
  echo "Install redis ? (yes / no)"
  read _INSTALL_REDIS
  clear
  echo "You select to install following things:"
  if [ "$_INSTALL_NODE" != "no" ];then
    echo "node.js"
  fi
  if [ "$_INSTALL_MONGODB" != "no" ];then
    echo "mongodb"
  fi
  if [ "$_INSTALL_REDIS" != "no" ];then
    echo "redis"
  fi
  echo ""
  echo "press ENTER to continue | press CTRL+C to stop"
  read
fi

# install node
if [ "$_INSTALL_NODE" != "no" ];then
  _install_node
fi

# install mongodb
if [ "$_INSTALL_MONGODB" = "yes" ];then
  _install_mongodb
fi

# install redis
if [ "$_INSTALL_REDIS" = "yes" ];then
  _install_redis
fi

exit 0;

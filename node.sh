#!/bin/bash

# Tested in Debian
clear
_command_exist () {
  command -v $1 >/dev/null 2>&1
}

if _command_exist wget; then
  echo "Please install wget first"
  read
  exit 1
fi

_install_node () {
  NODE_VERSION=`echo "$(wget https://nodejs.org/dist/index.json -O -)" | jq '.[0].version' | grep -o -e '[^"]*'`
  wget https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-x64.tar.xz
  tar -xvf node-$NODE_VERSION-linux-x64.tar.xz
  mv node-$NODE_VERSION-linux-x64 /usr/local/node
  rm /bin/node /bin/npm
  ln -s /usr/local/node/bin/node /bin/node
  ln -s /usr/local/node/bin/npm /bin/npm
}

_install_mongodb () {
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

clear
echo "Install node.js ? (yes / no)"
read install_node
echo "Install mongodb ? (yes / no)"
read install_mongodb
echo "Install redis ? (yes / no)"
read install_redis
clear
echo "You select to install following things:"
if [ "$install_node" != "no" ];then
  echo "node.js"
fi
if [ "$install_mongodb" != "no" ];then
  echo "mongodb"
fi
if [ "$install_redis" != "no" ];then
  echo "redis"
fi
echo ""
echo "press ENTER to continue | press CTRL+C to stop"
read

# install node
if [ "$install_node" != "no" ];then
  _install_node
fi

# install mongodb
if [ "$install_mongodb" = "yes" ];then
  _install_mongodb
fi

# install redis
if [ "$install_redis" = "yes" ];then
  _install_redis
fi

exit 0;

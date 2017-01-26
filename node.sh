#!/bin/bash
clear
command -v wget >/dev/null 2>&1 || { echo >&2 "Please install wget first"; read ; exit 1; }
clear
echo "Install node.js ? (yes / no)"
read install_node
echo "Install mongodb ? (yes / no)"
read install_mongodb
echo "Install redis ? (yes / no)"
read install_redis
clear
echo "You select to install following things:"
if [ "$install_node" = "yes" ];then
  echo "node.js"
fi
if [ "$install_mongodb" = "yes" ];then
  echo "mongodb"
fi
if [ "$install_redis" = "yes" ];then
  echo "redis"
fi
echo ""
echo "press ENTER to continue | press CTRL+C to stop"
read

# install node
if [ "$install_node" = "yes" ];then
  wget https://nodejs.org/dist/v6.9.4/node-v6.9.4-linux-x64.tar.xz
  tar -xvf node-v6.9.4-linux-x64.tar.xz
  mv node-v6.9.4-linux-x64 /usr/local/node
  rm /bin/node /bin/npm
  ln -s /usr/local/node/bin/node /bin/node
  ln -s /usr/local/node/bin/npm /bin/npm
fi

# install mongodb
if [ "$install_mongodb" = "yes" ];then
  wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.4.1.tgz
  tar -xvf mongodb-src-r3.4.1.tar.gz

  mv mongodb-src-r3.4.1 /usr/local/mongodb
  mkdir -p /data/db
  rm /bin/mongod /bin/mongo
  ln -s /usr/local/mongodb/bin/mongod /bin/mongod
  ln -s /usr/local/mongodb/bin/mongo /bin/mongo
fi

# install redis
if [ "$install_redis" = "yes" ];then
  wget http://download.redis.io/releases/redis-3.2.6.tar.gz
  tar -xvf redis-3.2.6.tar.gz
  mv redis-3.2.6 redis
  cd redis
  make
  cd ..
  mv redis
  rm /bin/redis-server /bin/redis-cli
  ln -s ./redis/src/redis-server /bin/redis-server
  ln -s ./redis/src/redis-cli /bin/redis-cli
fi

exit 0;

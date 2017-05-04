#!/bin/bash
# 开机自启脚本

# 开启redshift
gnome-terminal --window -- zsh -c 'redshift -t 6000:4500' &

# 开启overture
sudo sed -i '1i\nameserver 127.0.0.1' /etc/resolv.conf
gnome-terminal --window -- zsh -c 'cd /home/wangjie/Downloads && sudo -S ./overture-linux-amd64 -v' &

# 开启ss
ss-qt5 &

# 开发环境
gnome-terminal --window -- zsh -c 'sudo -S mongod' &
gnome-terminal --window -- zsh -c 'cd /home/wangjie/Workspace/adminMongo && npm run start' &

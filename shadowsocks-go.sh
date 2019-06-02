#!/bin/bash

# for ubuntu only
DEST="$HOME/.shadowsocks-go"
apt-get update
wget -O ss.zip https://github.com/shadowsocks/shadowsocks-go/releases/download/1.2.0/shadowsocks-server-linux64-1.2.0.zip
comamnd -v unzip > /dev/null 2>&1 || apt-get install unzip -y
unzip ss.zip -d $DEST
cat > $DEST/config.json << EOF
{
  "server": "0.0.0.0",
  "server_port": 8388,
  "password": "https://github.com/jsycdut",
  "method": "aes-256-cfb",
  "timeout": 600
}
EOF

wget -O kcp.tar.gz https://github.com/xtaci/kcptun/releases/download/v20190109/kcptun-linux-amd64-20190109.tar.gz
tar -xzf kcp.tar.gz --directory $DEST
ulimit -n 65535
cat >> /etc/sysctl.conf << EOF
net.core.rmem_max=26214400 // BDP - bandwidth delay product
net.core.rmem_default=26214400
net.core.wmem_max=26214400
net.core.wmem_default=26214400
net.core.netdev_max_backlog=2048 // proportional to -rcvwnd
EOF
cd $DEST
nohup ./shadowsocks-server -c config.json &
nohup ./server_linux_amd64 -t "0.0.0.0:8388" -l ":4000" -mode default -nocomp -sockbuf 54525952 -dscp 46 &





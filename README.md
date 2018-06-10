# shadowsocks-install-scripts
![build status](https://travis-ci.org/jsycdut/shadowsocks-install-scripts.svg?branch=master)

An one-click-script for installing shadowsocks on your Linux OS
 本项目用于在不同的Linux上安装Python版本的shadowsocks。

项目文件清单

1. install.sh
2. add-shadowsocks-user.sh

`install.sh`用于在Linux上安装Python版本的shadowsocks;
`add-shadowsocks-user.sh`用于添加shadowsocks用户，因为我的服务器上总是不止一个账号。
所以如果原有的shadowsocks的服务器被GFW封IP的话，那么在新的服务器上部署shadowsocks必须要把原有的用户移到新的服务器上，这种事情当然是写脚本操作了。这个脚本的核心在两个数组，`ports` `passwords`，前者是shadowsocks的端口，后者是shadowsocks对应端口的密码，然后就是调用流量管理脚本来添加端口和密码以及对应的流量限制了（默认50GB）。

# 注意

当前项目还是属于开发时期，很多变量和用户名称等都是写死的，等后期再改回来，如果有同学看到了这个项目，千万不要乱运行脚本，至少要把脚本看一遍再运行。


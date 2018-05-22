# shadowsocks-install-scripts
An one-click-script for installing shadowsocks on your Linux OS

> 本项目用于在Linux上安装Python版本的shadowsocks。

项目文件清单

1. install.sh，用于安装shadowsocks
2. add-shadowsocks-user.sh，用于添加shadowsocks用户

`install.sh`用于在Linux上安装Python版本的shadowsocks，而`add-shadowsocks-user.sh`用于添加shadowsocks用户，因为我的服务器上总是不止一个账号。
所以如果原有的shadowsocks的服务器被GFW封IP的话，那么在新的服务器上部署shadowsocks必须要把原有的用户移到新的服务器上，这种事情当然是写脚本操作了。

# 注意

当前项目还是属于开发时期，很多变量和用户名称等都是写死的，等后期再改回来，如果有同学看到了这个项目，千万不要乱运行脚本，至少要把脚本看一遍再运行。

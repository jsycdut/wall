## shadowsocks-install-scripts
![build status](https://travis-ci.org/jsycdut/shadowsocks-install-scripts.svg?branch=master)

本项目用于在不同的Linux上安装Python版本的shadowsocks。

## 项目文件清单

1. install.sh
2. add-shadowsocks-user.sh

`install.sh`用于在Linux上安装Python版本的shadowsocks;
`add-shadowsocks-user.sh`用于添加shadowsocks用户，因为我的服务器上总是不止一个账号。
所以如果原有的shadowsocks的服务器被GFW封IP的话，那么在新的服务器上部署shadowsocks必须要把原有的用户移到新的服务器上，这种事情当然是写脚本操作了。这个脚本的核心在两个数组，`ports` `passwords`，前者是shadowsocks的端口，后者是shadowsocks对应端口的密码，然后就是调用流量管理脚本来添加端口和密码以及对应的流量限制了（默认50GB）。

## 注意

一般而言，安装好了shadowsocks，然后就可以挂进程运行了，但是我个人担忧万一这个进程挂了咋办？或者说如果系统重启了，那是不是要很麻烦的去手动重启shadowsocks进程，而解决这一切的办法就是为shadowsocks整个启动脚本，（或者写个crontab定期重启进程，但是开机执行似乎还是没法），在这里我选择了写个服务的方式，Linux的启动脚本经历了sysVinit，upstart，以及现在的systemd，在现在很多版本的Linux的系统并行的情况下，我选择了只支持使用systemd作为启动脚本的Linux操作系统，Sorry guys！这些系统包括Debian 8及以上，Ubuntu 16.04及以上，CentOS 7及以上，如果你的系统版本不在这之列，脚本将不会安装shadowsocks启动服务，你可以根据你现在系统版本自己动手。

## 邀请
因为我本人日常使用的vps是Debian 8，手上还没有其他的发行版，虽然使用了Travis CI做持续集成，但是还是可能在实际运行中碰见不可预见的错误，所以如果你用的不是Debian 8，希望你能与我分享你的安装过程。

## 脚本运行原理
install.sh的运行原理是：

1. 判断Linux的类别和版本，即RHEL系列还是Debian系列，前者包括Redhat、CentOS，后者包括Debian、Ubuntu，这是为了弄明白工作环境，因为运行Python版本的shadowsocks需要一些依赖，安装这个依赖的一个办法是使用包管理器，而每一个特定的Linux版本都会有一个特定的包管理器，比如RHEL系列的使用yum，Debian系列的使用apt-get。

2. 下载必要的文件，包括shadowsocks Python版本的源代码，用于加解密的libsodium库，用于网络优化的bbr算法脚本等。

3. 安装且为shadowsocks添加启动脚本（只支持使用systemd作为启动脚本的系统）

4. 清理系统安装文件

add_user.sh的运行原理是：
1. 读取port和password数组的内容
2. 利用脚本添加shadowsocks用户

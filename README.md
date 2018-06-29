## shadowsocks-install-scripts
[![build status](https://travis-ci.org/jsycdut/shadowsocks-install-scripts.svg?branch=master)](https://travis-ci.org/jsycdut/shadowsocks-install-scripts)

本项目用于在Debian, Ubuntu, Cent OS, Arch等Linux操作系统上安装Python版本的Shadowsocks Server端。

## 项目进度
- [x] 安装Shadowsokcs
- [x] Debian
- [x] Ubuntu
- [ ] Cent OS && RHEL
- [ ] Arch
- [ ] SystemD for Shadowsocks
- [ ] iptables规则

## 安装原理说明
**install.sh**

1. 判断Linux的类别和版本，即RHEL系列还是Debian系列，前者包括Redhat、CentOS，后者包括Debian、Ubuntu，这是为了弄明白工作环境，因为运行Python版本的shadowsocks需要一些依赖，安装这个依赖的一个办法是使用包管理器，包管理器	取决于Linux发行版，比如RHEL系列的使用yum，Debian系列的使用apt-get或者apt。

2. 下载必要的文件，包括shadowsocks Python版本的源代码，用于加解密的libsodium库，用于网络优化的bbr算法脚本等。

3. 安装Shadowsocks

4. 为Shadowsocks添加启动脚本（只支持使用systemd作为启动脚本的系统）

5. 清理系统安装文件

**add_user.sh**

1. 读取port和password数组的内容
2. 利用脚本添加shadowsocks用户

## 关于启动脚本

一般而言，安装好了shadowsocks，然后就可以挂进程运行了，但是我个人担忧万一这个进程挂了咋办？或者说如果系统重启了，那是不是要很麻烦的去手动重启shadowsocks进程，而解决这一切的办法就是为shadowsocks整个启动脚本，（或者写个crontab定期重启进程，但是开机执行似乎还是没法），在这里我选择了写个服务的方式，Linux的启动脚本经历了sysVinit，upstart，以及现在的systemd，在现在很多版本的Linux的系统并行的情况下，我选择了只支持使用systemd作为启动脚本的Linux操作系统，Sorry guys！这些系统包括Debian 8+，Ubuntu 16.04+，CentOS 7+，如果你的系统版本不在这之列，脚本将不会安装shadowsocks启动服务，你可以根据你现在系统版本自己动手。

## shadowsocks-install-scripts
[![build status](https://travis-ci.org/jsycdut/shadowsocks-install-scripts.svg?branch=master)](https://travis-ci.org/jsycdut/shadowsocks-install-scripts)

本项目用于在Debian, Ubuntu, Cent OS, Arch等Linux操作系统上安装Python版本的Shadowsocks Server端。

## 项目进度
- [x] 安装Shadowsokcs
- [x] Debian 8 
- [x] Debian 9
- [x] Ubuntu 14.04  
- [x] Ubuntu 16.04
- [x] Cent OS 6 
- [x] Cent OS 7
- [ ] Arch
- [x] Systemd for Shadowsocks
- [x] SysVinit for shadowsocks
- [x] bbr (TCP拥塞控制)
- [ ] iptables规则

## 使用方法
**只需要顺序执行如下命令即可完成Shadowsocks的安装**
```bash
git clone https://github.com/jsycdut/shadowsocks-install-scripts
cd shadowsocks-install-scripts
sudo ./install.sh
```
**注意脚本需要root权限来运行。**
脚本会自动在你的Linux上安装Shadowsocks的server端，安装完成后脚本提示server端的IP，端口，密码和加密方式等信息，显示效果如下，这里除了IP和你的Linux服务器有关，其余全都是预设的值。

```
Shadowsocks started! Enjoy yourself!
Your Shadowsocks Serverside Information as below
Server IP:   xxxx
Server Port: 8388
Password:    https://github.com/jsycdut
Method:      aes-256-cfb
```
## 安装原理说明
* `install.sh`

1. 判断Linux的类别和版本，即RHEL系列还是Debian系列，前者包括Redhat、CentOS，后者包括Debian、Ubuntu，这是为了弄明白工作环境，因为运行Python版本的shadowsocks需要一些依赖，安装这个依赖的一个办法是使用包管理器，包管理器	取决于Linux发行版，比如RHEL系列的使用yum，Debian系列的使用apt-get或者apt。

2. 下载必要的文件，包括shadowsocks Python版本的源代码，用于加解密的libsodium库，用于网络优化的bbr算法脚本等。

3. 安装Shadowsocks

4. 为Shadowsocks添加启动脚本（只支持使用systemd作为启动脚本的系统）

5. 安装bbr提升TCP性能

* `add_user.sh`

1. 读取port和password数组的内容
2. 利用脚本添加shadowsocks用户

## bbr的安装
bbr用于控制tcp网络拥塞，性能相当不错，当前使用的脚本不支持CentOS系列内核，这一点需要注意，另外，在debian系统上安装bbr的时候，都会比较顺利，但是在Ubuntu上安装的时候，需要做两次选择，分别是选择引导菜单为`install the package maintainer's version`和移除旧内核安装新内核，这一点在`abort kernel removal`上选择`NO`，如下图

**注意以下图片针对Ubuntu系统，其余系统可以参考**

* 选择 `install the package maintainer's version`
![grub modification](https://raw.githubusercontent.com/jsycdut/shadowsocks-install-scripts/master/media/ubuntu-bbr-installation.png)


* `abort keep kernel removal`选择NO
![keep removing old kernel](https://raw.githubusercontent.com/jsycdut/shadowsocks-install-scripts/master/media/no-abort-removal.png)


## 关于启动脚本

启动脚本用于开机启动shadowsocks服务运行，另外一方面支持使用service命令来管理shadowsocks的启动，结束，重启以及状态查询
在安装脚本中，对当前Linux的启动系统进行了判断，同时支持了sysvinit和systemd两种，安装完成后使用上面对应的命令即可进行服务的管理，一般Ubuntu 15.04+， CentOS 7+， Debian 8+等系统都是systemd，之前的系统都可以使用sysvinit。
如何判断当前是sysvinit还是systemd？ 使用`ps -p 1 | grep systemd && grep "systemd"`此条命令即可，如果输出systemd，那么当前系统就是由systemd启动的，如果没有任何输出，那么就不是systemd，就可以认定为sysvinit（其实还有一种upstart技术，但是sysvinit更古老，比如upstart，我更喜欢sysvinit那种风格的脚本）。

* shadowsocks服务管理
```
service shadowsocksd {start|stop|restart|status}

# 关于命令选项
# start   启动shadowsocks
# stop    停止shadowsocks
# restart 重启shadowsocks
# status  查询shadowsocks状态
```

* 查询服务状态示例
```
root@vultr:~# service shadowsocksd status
● shadowsocksd.service - LSB: This is a sysvinit style init script for shadowsocks
   Loaded: loaded (/etc/init.d/shadowsocksd; bad; vendor preset: enabled)
   Active: active (running) since Sat 2018-10-27 06:24:49 UTC; 1 day 2h ago
     Docs: man:systemd-sysv-generator(8)
  Process: 1104 ExecStart=/etc/init.d/shadowsocksd start (code=exited, status=0/SUCCESS)
    Tasks: 6
   Memory: 29.6M
      CPU: 17.028s
   CGroup: /system.slice/shadowsocksd.service
           ├─1599 /usr/bin/python /usr/local/bin/ssserver -qq -c /etc/shadowsocks.json -d start
           ├─1601 /usr/bin/python /usr/local/bin/ssserver -qq -c /etc/shadowsocks.json -d start
           ├─1602 /usr/bin/python /usr/local/bin/ssserver -qq -c /etc/shadowsocks.json -d start
           ├─1603 /usr/bin/python /usr/local/bin/ssserver -qq -c /etc/shadowsocks.json -d start
           ├─1604 /usr/bin/python /usr/local/bin/ssserver -qq -c /etc/shadowsocks.json -d start
           └─1605 /usr/bin/python /usr/local/bin/ssserver -qq -c /etc/shadowsocks.json -d start
```


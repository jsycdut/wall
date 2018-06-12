#!/usr/bin/env bash

cat << -EOF
####################### Statement ################################
# Author: jsycdut <jsycdut@gmail.com>
# Desc:   Install Shadowsocks(Python) in Debian 8+, Ubuntu 16+
#         Redhat 7+, CentOS 7+, Arch
###################### Statement ################################
-EOF

######################### Why I write this shacript##################################
# I have read some one-click-shadowsocks-install-scripts, but there is no perfect 
# one, right? As a developer, I want more, so I decide to write a new one. The
# scripts I have read actually work well, however, I want to add some new features,
# such as a shadowsocks service, the reason why I want to do this is my server will
# go down someday, and I do not want to restart it manually because I am lazy.
# Making a  shadowsocks service sounds nice.
######################### Why I write this shacript##################################

########################### How this shacript works ###################################
# As a linux user, or just unix-like user, we are taught to be KISS- Keep It Simple and
# Stupid, but we are so lazy, If we write every Linux distribution a script, oh that's
# not cool. Writting a one-click-shacript is not so much complex as you think, actually
# it's really simple and full of joy.
# The way to write a shacript is stated as follow
#
# 1. Judge what linux distribution you are using, simply because we will add firewall 
#    rules to your machine, different linux may use different firewall packages and service
#    tools.
# 
# 2. Download the encrytion library which will be used by shadowsocks, we use libsodium
# 
# 3. Download shadowsocks's source code from github
# 
# 4. Install shadowsocks on your linux
# 
# 5. Add a service to your shadowsocks in case of your linux down someday or make it run
#    automatically when your linux start.
# 
# 6. Remove all the files we downloaded to keep your linux clean.
########################### How this shacript works ###################################

# exit when hit error
set -e

# prompt_color
info='\033[42;37m'
warning='\033[43;37m'
error='\033[41;37m'
end='\033[0m'

if [[ $EUID -ne 0 ]]; then
	echo -e "${error}ERROR!!! ${end} Please run this script as root"
	exit 1
fi

os_name=''
os_version=''
os_pm=''

# prompt_color
# greem background white characters
info='\033[42;37m'
# yellow background white characters
warning='\033[43;37m'
# red background white characters
error='\033[41;37m'
# plain characters
end='\033[0m'

# Judging the os's name and version
check_os(){
	if [[ `ls /etc/ | grep -Ei "centos|redhat"` ]]; then
		os_name="rhel"
		os_pm='yum'
		os_version=`rpm -q centos-release | awk -F '-' '{print $3}'`
	fi
	if [[ -z $os_name ]]; then
		os_name=`cat /etc/*release | grep -i pretty_name= | awk -F '"' '{print $2}'`
		os_version=`cat /etc/*release | grep -i version_id= |awk -F '"' '{print $2}'`
	fi
	if [[ `echo $os_name | grep -Ei "ubuntu|debian"` ]]; then
		os_pm='apt-get'
	fi
	echo "We detected your system information as below"
	echo -e "${info} Linux Distribution:  ${end} $os_name"
	echo -e "${info} Linux      Version:  ${end} $os_version"
	echo -e "${info} Package    Manager:  ${end} $os_pm"
}

# necessary file resource
libsodium_name="libsodium-1.0.16"
libsodium_url="https://github.com/jedisct1/libsodium/releases/download/1.0.16/libsodium-1.0.16.tar.gz"
libsodium_url_backup="http://178.62.201.152:6291/libsodium-1.0.16.tar.gz"
bbr_url="https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/bbr.sh"
bbr_url_backup="http://178.62.201.152:6291/bbr.sh"
shadowsocks_url="https://github.com/shadowsocks/shadowsocks/archive/2.9.1.zip"
shadowsocks_source_code_folder="shadowsocks_2.9.1"
base="/tmp/preinstall-shadowsocks"

preinstall(){
	sudo $os_pm install awk wget unzip python python-devel python-setuptools openssl openssl-devel gcc make automake autoconf libtool automake -y -q
	#echo -e "${info} info ${end} Now making preinstall folder in /tmp"
	#echo -e "${info} info ${end} Creating directory $base" 
	mkdir -p $base
	cd $base
        #echo -e "${info} info ${end} Downloading essential files"
	wget -q --no-check-certificate -O $libsodium_name.tar.gz $libsodium_url
	if [[ ! -e $base/libsodium-1.0.16.tar.gz ]]; then
		wget -q --no-chech-certificate -O $libsodium_name.tar.gz $libsodium_url_backup

	fi
	wget -q --no-check-certificate -O bbr.sh $bbr_url
	if [[ ! -e $base/bbr.sh ]]; then
		wget -q --no-check-certificate -O bbr.sh $bbr_url_backup
	fi
	if [[ -e $base/bbr.sh ]]; then
		chmod u+x bbr.sh
	fi
	wget -q -O 2.9.1.zip $shadowsocks_url
	if [[ -e 2.9.1.zip ]]; then
		unzip -q 2.9.1.zip
	fi

}

install(){
	# TODO install all
	echo installing 
}
check_os 
preinstall 
echo "now download the files as below in $base"
ls $base | cat

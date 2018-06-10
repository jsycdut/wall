#!/usr/bin/env bash

cat << -EOF
################################# Statement #########################################
# Author: jsycdut <jsycdut@gmail.com>
# Description: This script is used for installing shadowsocks(python edition) on variety of Linux 
#              distributions, such as Ubuntu, Debian, Cent OS, Fedora, Arch. It may
#              take  a few weeks to write this script that I call it shacript, so 
#              just do it.
# We are using bash as our shell interpreter
# If you hit some troubles caused by shell interpreter
# Please contact the author via github issue or email <jsycdut@gmail.com>
################################# Statement #########################################

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

-EOF

set -e

if [[ $EUID -ne 0 ]]; then
	echo "ERROR!!! Please run this script as root"
	exit 1
fi

os_name=''
os_version=''
os_pm=''

# Judging the os's name and version
check_os(){
	if cat /proc/version | grep -Eqi "debian"; then
		$os_name="Debian"
		$os_pm="apt-get"
	elif cat /proc/version | grep -Eqi "ubuntu"; then
		$os_name="Ubuntu"
		$os_pm="apt-get"
	elif cat /proc/version | grep -Eqi "centos|red hat |redhat"; then
		$os_name="Redhat_series"
		$os_pm="rpm"
	fi
	if $os_name=="Debian" -a -e /etc/*release; then 
		$os_version=cat/etc/*release | grep -i "version=" | awk -F '=' '{print $2}'
	elif $os_name=="Ubuntu" -a -e /etc/*release; then
		$os_version=cat /etc/*release | grep -i "version=" | awk -F '=' '{print $2}'
	elif $os_name=="Redhat_series" -a -e /etc/*release; then
		$os_version=cat /etc/*release | grep -i "version=" | awk -F '=' '{print $2}'
	fi
	cat << -EOF
	=======================System Infomation"=============
	Linux_name: $os_name 
	Linux_version: $os_version 
	======================================================
	-EOF
	
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
	echo "Now making preinstall folder in your /tmp"
	echo "mkdir $base" 
	mkdir -pv $base
	cd $base
        echo "downloading essential files"
	wget --no-check-certificate -O $libsodium_name.tar.gz $libsodium_url
	if [[ ! -e $base/libsodium-1.0.16.tar.gz ]]; then
		wget --no-chech-certificate -O $libsodium_name.tar.gz $libsodium_url_backup

	fi
	wget --no-check-certificate -O bbr.sh $bbr_url
	if [[ ! -e $base/bbr.sh ]]; then
		wget --no-check-certificate -O bbr.sh $bbr_url_backup
	fi
	if [[ -e $base/bbr.sh ]]; then
		chmod u+x bbr.sh
	fi
	wget -O $shadowsocks_url 
	if [[ -e 2.9.1.zip ]]; then
		unzip -q 2.9.1.zip
	fi
}

check_os 
preinstall && ls /tmp/preinstall-shadowsocks | cat

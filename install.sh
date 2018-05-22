#!/usr/bin/env bash

cat << -EOF
################################# Statement #########################################
# Author: jsycdut <jsycdut@gmail.com>
# Description: This script is used for installing shadowsocks on variety of Linux 
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
# 1. Judge what linux distribution you are using, simpley because we will add firewall 
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


if [[ $EUID -ne 0 ]]; then
	echo "ERROR!!! Please run this script as root"
	exit 1
fi

os_name=to_be_detected
os_version=to_be_detected

# Judging the os's name and version
check_os(){
	if [[ -e /etc/*-release  ]]
	then 
		echo 'Judging from /etc/*-release'	
	elif [ -e /proc/version ]
	then 
		echo 'Judging from /proc/version'	
	elif [[ -e /etc/issue ]]
	then
		echo 'Juging from /etc/issue'
	else
		echo "Error! can't judge the os you are using"
		exit 1
	fi
}

libsodium_name="libsodium-1.0.16"
libsodium_url="https://github.com/jedisct1/libsodium/releases/download/1.0.16/libsodium-1.0.16.tar.gz"
libsodium_url_backup=""
bbr_url="https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/bbr.sh"

#!/usr/bin/env bash

cat << -EOF
####################### Statement ################################
# Author: jsycdut <jsycdut@gmail.com>
# Desc:   Install Shadowsocks(Python) in Debian 8+, Ubuntu 16+
#         Redhat 7+, CentOS 7+, Arch
####################### Statement ################################
-EOF

set -e
# notification functions
info(){
  echo -e "\033[42;37m $@ \033[0m"
}

warn(){
  echo -e "\033[43;37m $@ \033[0m"
}

error(){
  echo -e "\033[41;37m $@ \033[0m"
}
if [[ $EUID -ne 0 ]]; then
  error "ERROR! You need root privilege to run this script!!!"
  exit 1
fi

os_name=''
os_version=''
os_pm=''

# get  os's name and version
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
  info "We detected your system information as below"
  info "Linux Distribution:"  $os_name
  info "Linux      Version:"  $os_version
  info "Package    Manager:"  $os_pm
}

# necessary file resource
base="~/shadowsocks-install"

file_names=(
"libsodium.tar.gz"
"bbr.sh"
"shadowsocks-2.9.1.zip"
)

file_urls=(
"https://github.com/jedisct1/libsodium/releases/download/1.0.16/libsodium-1.0.16.tar.gz"
"https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/bbr.sh"
"https://github.com/shadowsocks/shadowsocks/archive/2.9.1.zip"
)

file_backup_urls=(
"http://listen-1.com:6294/libsodium-1.0.16.tar.gz"
"http://listen-1.com:6294/bbr.sh"
"http://listen-1.com:6294/shadowsocks-2.9.1-python-source-code.zip"
)

preinstall(){
  $os_pm update
  common_packages="gcc make automake autoconf python python-setuptools
  wget unzip tar openssl libtool curl"
  # same functional package got different name in different paltform
  apt_packages="python-dev libssl-dev "
  yum_packages="python-devel openssl-devel"
  $os_pm -y install $common_packages 
  if [[ $os_pm == "apt-get" ]]; then
    apt-get install -y $apt_packages 
  elif [[ $os_pm == "yum" ]]; then
    yum install -y $yum_packages 
  fi
  mkdir -p $base
  info "Created directory $base 🐇"
  cd $base
  info "Downloading essential files, Please wait or drink a cup of coffee ☕"
  for((i = 0; i<${#file_names[*]}; i++)); do
    wget -q --no-check-certificate -O ${file_names[$i]} ${file_urls[$i]}
  done
}
check_os
preinstall
info `ls $base`

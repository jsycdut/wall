#!/usr/bin/env bash
source lib.sh
cat << EOF
####################### Statement ################################
# Author: jsycdut <jsycdut@gmail.com>
# Desc:   Install Shadowsocks(Python) in Debian 8+, Ubuntu 16+
#         Redhat 7+, CentOS 7+, Arch
####################### Statement ################################
EOF

CWD=`pwd`

#set -e
# check privilege
if [[ $EUID -ne 0 ]]; then
  error "ERROR! You need root privilege to run this script!!!"
  exit 1
fi

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

preinstall(){
  $os_pm update
  common_packages="gcc make automake autoconf python python-setuptools
  wget unzip tar openssl libtool curl"
  # same functional package got different name in different paltform
  apt_packages="python-dev libssl-dev "
  yum_packages="python-devel openssl-devel net-tools"
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
  for((i=0; i<${#file_names[*]}; i++)); do
    if [[ ! -e ${file_names[$i]} ]]; then
      wget -q --no-check-certificate -O ${file_names[$i]} ${file_backup_urls[$i]}
    fi
  done
}

install(){
  cd $base && sudo tar zxf ${file_names[0]}
  cd libsodium-1.0.16 && ./configure --prefix=/usr && make && make install 
  if [[ $? -ne 0 ]]; then 
    error "ERROR! Install libsodium failed! Script Aborted..."
  else
    info "Good! Install libsodium succeeded!"
  fi
  cd $base && sudo unzip -q  -d shadowsocks $base/shadowsocks-2.9.1.zip && cd $base/shadowsocks/shadowsocks-2.9.1 
  python setup.py install 
  if [[ $? -ne 0 ]]; then
    error "ERROR! Install shadowsocks failed! Scritp Aborted..."
  else
    info "Fantastic! Install shadowsocks succeeded!"
  fi
}

install_service(){
  local systemd=$(ps -p 1 | grep systemd && echo "systemd")
  if [ -n "$systemd" ]; then
    cat > "/lib/systemd/system/shadowsocks.service" << EOF
[Unit]
Description=Shadowsocks systemd service

[Service]
Type=fork
ExecStart=/usr/local/bin/ssserver -qq -c /etc/shadowsocks.json -d start
ExecStop=/usr/local/bin/ssserver -d stop

[Install]
WantedBy=multi-user.target
EOF
  else
    cp "$CWD"/shadowsocksd /etc/init.d
    ln -s /etc/init.d/shadowsocksd  /etc/rc0.d/K78shadowsocksd
    ln -s /etc/init.d/shadowsocksd  /etc/rc1.d/K78shadowsocksd
    ln -s /etc/init.d/shadowsocksd  /etc/rc2.d/S55shadowsocksd
    ln -s /etc/init.d/shadowsocksd  /etc/rc3.d/S55shadowsocksd
    ln -s /etc/init.d/shadowsocksd  /etc/rc4.d/S55shadowsocksd
    ln -s /etc/init.d/shadowsocksd  /etc/rc5.d/S55shadowsocksd
    ln -s /etc/init.d/shadowsocksd  /etc/rc6.d/K78shadowsocksd
  fi
}

# launch shadowsocks in daemon mode
launch(){
  sudo ssserver -qq -c /etc/shadowsocks.json -d start > /dev/null 2>&1
  if [[ $? -eq 0 ]]; then
    info "Shadowsocks started! Enjoy yourself!"
  else
    error "Failed to start Shadowsocks! Aborted!"
  fi
}

install_bbr(){
  echo
  info "Shadowsocks has been installed and already launched"
  info "There is an additional step for you: BBR for tcp congestion control"
  info "BBR can improve the performance of your shadowsocks, but it needs the latest version of the kernel"

  info "Now we are going to install bbr to improve the performance of shadowsocks"
  
  read -t 20 -p "press [Y/y] to continue, [N/n] or any other key to give up (default[N/n]) :" k
  case "$k" in
    Y|y)
      info "Just follow the instrunction of the script and install it, do not forget restart this linux ater the bbr installation complete"
      cd $base && chmod +x bbr.sh && bash bbr.sh
      ;;
    *)
      echo
      info "OK, bbr will not be installed, enjoy yourself." 
      ;;
  esac
}

check_os
preinstall
#get_ip
get_ip_by_api
config
install
install_service
launch
show_shadowsocks_info
install_bbr

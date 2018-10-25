#! /bin/bash

# the ports shadowsocks using
ports=(
6666
7777
8888)

# the password corresponding to the ports above
passwords=(
password_for_port_6666
password_for_port_7777
password_for_port_8888
)

# bandwidth limit, not essential
bandwidth=(

)

# add users automatically by using a loop
adduser(){
  if [[ ${#ports[@]} -ne ${#passwords[@]} ]]; then
    echo 'ports和passwords两数组长度不匹配'
    exit 1
  fi

  for (( i = 0; i < ${#ports[@]}; i++ )); 
  do
    cd /home/jsy/shadowsocks/ss-bash/ && ./ssadmin.sh add ${ports[$i]} ${passwords[$i]} 50GB
  done
}
adduser

#! /bin/bash
readonly base="`pwd`/shadowsocks-install"
os_name=''
os_version=''
os_pm=''
ip=''

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
"http://listen-1.com:6294/shadowsocks-2.9.1.zip"
)

# notification functions
info(){
  echo -e "\033[32m$@\033[0m"
}

error(){
  echo -e "\033[31m$@\033[0m"
}

get_ip(){
  if [[ $os_pm == 'apt-get' ]]; then
    ip=$( ifconfig | grep '.*inet[[:space:]]addr.*' | grep -v '.*addr:127.*\|.*addr:10\..*' | awk -F ' ' '{print $2}' | awk -F ':' '{print $2}' )
  elif [[ $os_pm == 'yum' ]]; then
    ip=$( ifconfig | grep '.*inet[[:space:]]' | grep -v '[[:space:]]127\|[[:space:]]10\.' | awk -F' ' '{print $2}' ) 
  fi
}

get_ip_by_api(){
  ip=$(curl https://httpbin.org/ip | awk -F '"' '{print $4}')
}

config(){
  cat > /etc/shadowsocks.json << EOF 
  {
    "server":"0.0.0.0",
    "server_port":8388,
    "password":"https://github.com/jsycdut",
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open":true,
    "workers":5
  }
EOF
}

show_shadowsocks_info(){
  cat << EOF
`info  `
`info "Your Shadowsocks Serverside Information Shows as Below (๑¯◡¯๑)"`
`info "Server IP:  " $ip`
`info "Server Port: 8388"`
`info "Password:    https://github.com/jsycdut"`
`info "Method:      aes-256-cfb"`
🌈  `info " Ggood day or bad day, make it a valuable day."`
EOF
}

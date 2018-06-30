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
  echo -e "\033[32m $@ \033[0m"
}

error(){
  echo -e "\033[31m $@ \033[0m"
}
get_ip(){
  ip=$( ifconfig | grep "inet addr" | grep -v ":10 \|:127" | awk -F ' ' '{print $2}' | awk -F ':' '{print $2}' )
	echo $ip
}

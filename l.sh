#!/bin/bash

apt-get update && apt-get -y install mysql-server

mysql_secure_installation

chown -R mysql:mysql /var/lib/mysql/ && chmod -R 755 /var/lib/mysql/

apt-get -y install nginx php5 php5-fpm php5-cli php5-mysql php5-mcrypt

# Install Webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
cat > /etc/nginx/nginx.conf <<END3
user www-data;
worker_processes 1;
pid /var/run/nginx.pid;
events {
	multi_accept on;
  worker_connections 1024;
}
http {
	gzip on;
	gzip_vary on;
	gzip_comp_level 5;
	gzip_types    text/plain application/x-javascript text/xml text/css;
	autoindex on;
  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;
  server_tokens off;
  include /etc/nginx/mime.types;
  default_type application/octet-stream;
  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;
  client_max_body_size 32M;
	client_header_buffer_size 8m;
	large_client_header_buffers 8 8m;
	fastcgi_buffer_size 8m;
	fastcgi_buffers 8 8m;
	fastcgi_read_timeout 600;
  include /etc/nginx/conf.d/*.conf;
}
END3
mkdir -p /home/vps/public_html
cat > /home/vps/public_html/index.html <<END
<?
######################################################
# Configuration
######################################################
$server = "localhost"; // Your mySQL Server, most cases "localhost"
$db_user = "root"; // Your mySQL Username
$db_pass = "$Aa416202002707"; // Your mySQL Password
$database = "db_name"; // Database Name
$timeoutseconds = 1; //ตั้งเวลาสำหรับเช็คคนออนไลน์ เป็นวินาที 300= 5 นาที
# End Configuration - DO NOT EDIT BEHIND THIS LINE !!!
###############################################
if($action=="Install"){
mysql_connect($server, $db_user, $db_pass) or die ("Useronline Database CONNECT Error");
mysql_db_query($database, "CREATE TABLE useronline ( timestamp int(15) NOT NULL default '0', ip varchar(40) NOT NULL default '', file varchar(100) NOT NULL default '', PRIMARY KEY (timestamp), KEY ip (ip), KEY file (file)) TYPE=MyISAM") or die("Useronline Database Install Error");
echo "Useronline is install completed! ";
} else {
$timestamp=time();
$timeout=$timestamp-$timeoutseconds;
mysql_connect($server, $db_user, $db_pass) or die ("Useronline Database CONNECT Error");

// เมื่อมีการโหลดเวบเพจขึ้นมา จะกำหนดให้เก็บค่า IP ของคนเยี่ยมชม และเวลาที่โหลดหน้าเวบเพจ ลงในฐานข้อมูลทันที
mysql_db_query($database, "INSERT INTO useronline VALUES ('$timestamp','$REMOTE_ADDR','$PHP_SELF')") or die("Useronline Database INSERT Error");

//หลังจากนั้นเช็คว่า คนเยี่ยมชมหมายเลข IP ใด เกินกำหนดเวลาที่ตั้งไว้แล้ว ให้ลบออกฐานข้อมูล
mysql_db_query($database, "DELETE FROM useronline WHERE timestamp<$timeout") or die("Useronline Database DELETE Error");

//ให้นับจำนวนเรคคอร์ดในตารางทั้งหมด ที่มี IP ต่างกัน ว่ามีเท่าไหร่ โดย IP เดียวกันให้นับเป็นคนเดียว
$result=mysql_db_query($database, "SELECT DISTINCT ip FROM useronline WHERE file='$PHP_SELF'") or die("Useronline Database SELECT Error");

//ค่าที่ได้ ก็คือจำนวนคนออนไลน์นั่นเอง
$user =mysql_num_rows($result);
mysql_close();

//Show Useronline
if ($user==1) {
echo"$user User online";
} else {
echo"$user Users online";
}
}
?>
END
echo "<?phpinfo(); ?>" > /home/vps/public_html/info.php
args='$args'
uri='$uri'
document_root='$document_root'
fastcgi_script_name='$fastcgi_script_name'
cat > /etc/nginx/conf.d/vps.conf <<END4
server {
  listen       81;
  server_name  127.0.0.1 localhost;
  access_log /var/log/nginx/vps-access.log;
  error_log /var/log/nginx/vps-error.log error;
  root   /home/vps/public_html;
  location / {
    index  index.html index.htm index.php;
    try_files $uri $uri/ /index.php?$args;
  }
  location ~ \.php$ {
    include /etc/nginx/fastcgi_params;
    fastcgi_pass  127.0.0.1:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
  }
}
END4
/etc/init.d/nginx restart
/etc/init.d/php5-fpm restart

# Initialization var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

# Go to root
cd

# Disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# Install wget and curl
apt-get update
apt-get -y install wget curl

# Set Location GMT +7
ln -fs /usr/share/zoneinfo/Asia/Thailand /etc/localtime

# Set Locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# Set repo
cat > /etc/apt/sources.list <<END
deb http://cdn.debian.net/debian wheezy main contrib non-free
deb http://security.debian.org/ wheezy/updates main contrib non-free
deb http://packages.dotdeb.org wheezy all
deb http://download.webmin.com/download/repository sarge contrib
deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib
END
wget "https://raw.githubusercontent.com/nwqionnwkn/OPENEXTRA/master/Config/dotdeb.gpg"
wget "https://raw.githubusercontent.com/nwqionnwkn/OPENEXTRA/master/Config/jcameron-key.asc"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg
cat jcameron-key.asc | apt-key add -;rm jcameron-key.asc

# Update
apt-get update

# Install Essential Package
apt-get -y install nano iptables dnsutils openvpn screen whois ngrep unzip unrar

# Install Vnstat
apt-get -y install vnstat
vnstat -u -i eth0

# Install OpenVPN
wget -O /etc/openvpn/openvpn.tar "https://github.com/nwqionnwkn/OPENEXTRA/raw/master/Config/openvpn.tar"
cd /etc/openvpn/
tar xf openvpn.tar
cat > /etc/openvpn/1194.conf <<END
port 1194
proto tcp
dev tun

ca /etc/openvpn/keys/ca.crt
dh /etc/openvpn/keys/dh1024.pem
cert /etc/openvpn/keys/server.crt
key /etc/openvpn/keys/server.key

plugin /usr/lib/openvpn/openvpn-auth-pam.so /etc/pam.d/login
client-cert-not-required
username-as-common-name

server 192.168.100.0  255.255.255.0
push "redirect-gateway def1"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"

cipher none
comp-lzo

keepalive 5 30

persist-key
persist-tun
client-to-client
status log.log
verb 3
mute 10
END
/etc/init.d/openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables_new.conf
cat > /etc/network/if-up.d/iptables <<END
#!/bin/sh
iptables-restore < /etc/iptables_new.conf
END
chmod +x /etc/network/if-up.d/iptables
/etc/init.d/openvpn restart

# Setting Port SSH
cd
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
/etc/init.d/ssh restart

# Install Dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 443 -p 80"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/ssh restart
/etc/init.d/dropbear restart

# Install Squid3
cd
apt-get -y install squid3
cat > /etc/squid3/squid.conf <<END
acl manager proto cache_object
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst xxxxxxxxx-xxxxxxxxx/255.255.255.255
http_access allow SSH
http_access allow manager localhost
http_access deny manager
http_access allow localhost
http_access deny all
http_port 8080
coredump_dir /var/spool/squid3
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname openextra.net
END
sed -i $MYIP2 /etc/squid3/squid.conf;

# Install Script
cd /usr/local/bin
wget https://raw.githubusercontent.com/nwqionnwkn/OPENEXTRA/master/Config/menu
wget https://raw.githubusercontent.com/nwqionnwkn/OPENEXTRA/master/Config/speedtest
chmod +x menu
chmod +x speedtest
echo ""
echo "..... Installing 98% ...restarting service."

# Finishing
cd
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/nginx restart
service openvpn restart
service cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
service vnstat restart
service squid3 restart
rm -rf ~/.bash_history && history -c

# info
clear
echo "====================================================="
echo ""
echo " - OpenVPN  : TCP Port 1194"
echo " - OpenSSH  : Port 22, 143"
echo " - Dropbear : Port 80, 443"
echo " - Squid3   : Port 8080"
echo ""
echo "====================================================="
echo "หลังจากติดตั้งสำเร็จ... กรุณาพิมพ์คำสั่ง menu เพื่อไปยังขั้นตอนถัดไป"
echo "====================================================="
echo "-------- Script by Mnm Ami"
cd
rm -f /root/Install.sh

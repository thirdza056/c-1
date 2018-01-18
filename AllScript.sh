#!/bin/bash

# Check root
if [[ "$EUID" -ne 0 ]]; then
	echo ""
	echo "     กรุณาเข้าสู่ระบบผู้ใช้ root ก่อนทำการติดตั้งสคริปท์"
	echo "     คำสั่งเข้าสู่ระบบผู้ใช้ root คือ sudo -i"
	echo ""
fi

# Set Localtime GMT +7
ln -fs /usr/share/zoneinfo/Asia/Thailand /etc/localtime

clear

# Color
color1='\e[031;1m'
color3='\e[0m'

# Menu Function
echo ""
echo -e "${color1}  (\_(\  ${color3}"
echo -e "${color1} (=’ :’) :* ${color3} Script by Mnm Ami"
echo -e "${color1}  (,(”)(”) °.¸¸.• ${color3}"
echo ""
echo -e "FUNCTION SCRIPT ${color1}✿.｡.:* *.:｡✿*ﾟ’ﾟ･✿.｡.:*${color3}"
echo ""
echo -e "|${color1}1${color3}|  OPENVPN (TERMINAL CONTROL)"
echo -e "|${color1}2${color3}|  OPENVPN (PRITUNL CONTROL)"
echo -e "|${color1}3${color3}|  SSH + DROPBEAR"
echo -e "|${color1}4${color3}|  WEB PANEL"
echo -e "|${color1}5${color3}|  VNSTAT (CHECK BANDWIDTH or DATA)"
echo -e "|${color1}6${color3}|  SETUP ALL FUNCTION"
echo ""
read -p "กรุณาเลือกฟังก์ชั่นที่ต้องการติดตั้ง (ตัวเลข)  : " x

if test $x -eq 1; then
	if [[ -e /etc/debian_version ]]; then
		OS="debian"
		VERSION_ID=$(cat /etc/os-release | grep "VERSION_ID")
		IPTABLES='/etc/iptables/iptables.rules'
		SYSCTL='/etc/sysctl.conf'

		if [[ "$OS" = 'debian' ]]; then

			# Debian 8
			if [[ "$VERSION_ID" = 'VERSION_ID="8"' ]]; then
			mkdir /root/backup
			cp /etc/apt/sources.list /root/backup
			# Ubuntu 14.04
			elif [[ "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
			
			# Ubuntu 16.04
			elif [[ "$VERSION_ID" = 'VERSION_ID="16.04"' ]]; then
			
			else
			echo ""
			exit

		fi
	fi
	
elif test $x -eq 2; then

	if [[ -e /etc/debian_version ]]; then
		OS="debian"
		VERSION_ID=$(cat /etc/os-release | grep "VERSION_ID")
		IPTABLES='/etc/iptables/iptables.rules'
		SYSCTL='/etc/sysctl.conf'

		if [[ "$OS" = 'debian' ]]; then

			# Debian 8
			if [[ "$VERSION_ID" = 'VERSION_ID="8"' ]]; then
				cd
				# Pritunl
				sudo tee -a /etc/apt/sources.list.d/mongodb-org-3.6.list << EOF
				deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.6 main
				EOF
				sudo tee -a /etc/apt/sources.list.d/pritunl.list << EOF
				deb http://repo.pritunl.com/stable/apt jessie main
				EOF
				sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
				sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
				sudo apt-get update
				sudo apt-get --assume-yes install pritunl mongodb-org
				sudo systemctl start mongod pritunl
				sudo systemctl enable mongod pritunl
				
				# Squid Proxy
				apt-get -y install squid3
				cp /etc/squid3/squid.conf /etc/squid3/squid.conf.orig
				cat > /etc/squid3/squid.conf <<-END
				http_port 8080
				acl localhost src 127.0.0.1/32 ::1
				acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
				acl localnet src 10.0.0.0/8
				acl localnet src 172.16.0.0/12
				acl localnet src 192.168.0.0/16
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
				http_access allow localnet
				http_access allow localhost
				http_access deny all
				refresh_pattern ^ftp:           1440    20%     10080
				refresh_pattern ^gopher:        1440    0%      1440
				refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
				refresh_pattern .               0       20%     4320
				END
				MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
				sed -i s/xxxxxxxxx/$MYIP/g /etc/squid3/squid.conf;
				/etc/init.d/squid3 restart
				sleep 2

				cd
				clear
				IP=`dig +short myip.opendns.com @resolver1.opendns.com`
				echo ""
				echo "==================================="
				echo "Install Pritunl Finish..."
				echo "Debian 8 Jessie version."
				echo "Source by Mnm Ami (Donate via TrueMoney Wallet : 082-038-2600)"
				echo ""
				echo "Proxy : $IP"
				echo "Port  : 8080"
				echo ""
				echo "http://$IP"
				echo ""
				pritunl setup-key
				echo ""
				echo "==================================="
				rm Pritunl.sh

			# Ubuntu 14.04
			elif [[ "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
				cd
				# Pritunl
				sudo tee -a /etc/apt/sources.list.d/mongodb-org-3.6.list << EOF
				deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.6 multiverse
				EOF
				sudo tee -a /etc/apt/sources.list.d/pritunl.list << EOF
				deb http://repo.pritunl.com/stable/apt trusty main
				EOF
				sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
				sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
				sudo apt-get update
				sudo apt-get --assume-yes install pritunl mongodb-org
				sudo service pritunl start
				
				# Squid Proxy
				apt-get -y install squid3
				cp /etc/squid3/squid.conf /etc/squid3/squid.conf.orig
				cat > /etc/squid3/squid.conf <<-END
				http_port 8080
				acl localhost src 127.0.0.1/32 ::1
				acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
				acl localnet src 10.0.0.0/8
				acl localnet src 172.16.0.0/12
				acl localnet src 192.168.0.0/16
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
				http_access allow localnet
				http_access allow localhost
				http_access deny all
				refresh_pattern ^ftp:           1440    20%     10080
				refresh_pattern ^gopher:        1440    0%      1440
				refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
				refresh_pattern .               0       20%     4320
				END
				MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
				sed -i s/xxxxxxxxx/$MYIP/g /etc/squid3/squid.conf;
				/etc/init.d/squid3 restart
				sleep 2

				cd
				clear
				IP=`dig +short myip.opendns.com @resolver1.opendns.com`
				echo ""
				echo "==================================="
				echo "Install Pritunl Finish..."
				echo "Ubuntu 14.04 Trusty version."
				echo "Source by Mnm Ami (Donate via TrueMoney Wallet : 082-038-2600)"
				echo ""
				echo "Proxy : $IP"
				echo "Port  : 8080"
				echo ""
				echo "http://$IP"
				echo ""
				pritunl setup-key
				echo ""
				echo "==================================="
				rm Pritunl.sh

			# Ubuntu 16.04
			elif [[ "$VERSION_ID" = 'VERSION_ID="16.04"' ]]; then
				cd
				# Pritunl
				
				clear
				IP=`dig +short myip.opendns.com @resolver1.opendns.com`
				echo ""
				echo "==================================="
				echo "Install Pritunl Finish..."
				echo "Ubuntu 16.04 Xenial version."
				echo "Source by Mnm Ami (Donate via TrueMoney Wallet : 082-038-2600)"
				echo ""
				echo "Proxy : $IP"
				echo "Port  : 8080"
				echo ""
				echo "http://$IP"
				echo ""
				pritunl setup-key
				echo ""
				echo "==================================="
				rm Pritunl.sh

			else
				cd
				clear
				echo ""
				echo "     ${color1}การติดตั้ง Pritunl รองรับเฉพาะ Debian 8 และ Ubuntu 14.04 - 16.04 เท่านั้น${color3}"
				echo ""
				echo "     Source by Mnm Ami"
				echo "     You can donate via truemoney wallet : 082-038-2600"
				echo ""
				rm Pritunl.sh
			fi
		fi
	fi

elif test $x -eq 3; then
	echo "กรุณารอสักนิด ขณะนี้ยังไม่ได้ติดตั้งคำสั่งนี้"

elif test $x -eq 4; then
	echo "กรุณารอสักนิด ขณะนี้ยังไม่ได้ติดตั้งคำสั่งนี้"

elif test $x -eq 5; then
	rm /etc/apt/sources.list
	cp /root/backup/sources.list /etc/apt/

elif test $x -eq 6; then
	echo "กรุณารอสักนิด ขณะนี้ยังไม่ได้ติดตั้งคำสั่งนี้"

else
	cd
	clear
	./AllScript.sh

fi

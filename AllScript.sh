#!/bin/bash

# Check root
if [[ "$EUID" -ne 0 ]]; then
	echo ""
	echo "กรุณาเข้าสู่ระบบผู้ใช้ root ก่อนทำการติดตั้งสคริปท์"
	echo "คำสั่งเข้าสู่ระบบผู้ใช้ root คือ sudo -i"
	echo ""
fi

# Set my IP
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

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
			mkdir /root/backup
			cp /etc/apt/sources.list /root/backup

elif test $x -eq 2; then

	if [[ -e /etc/debian_version ]]; then

	OS="debian"
	VERSION_ID=$(cat /etc/os-release | grep "VERSION_ID")
	IPTABLES='/etc/iptables/iptables.rules'
	SYSCTL='/etc/sysctl.conf'

		if [[ "$OS" = 'debian' ]]; then

			# Debian 8
			if [[ "$VERSION_ID" = 'VERSION_ID="8"' ]]; then

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

			cd
			apt-get -y install squid3

			echo ""
			echo "กรุณาตั้งชื่อโฮสเนมพร็อกซี่ของคุณ"
			read -p "Enter Your Proxry Hostname : " Hostname

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
			visible_hostname $Hostname
			END
			sed -i $MYIP2 /etc/squid3/squid.conf;
			/etc/init.d/squid3 restart

			fi

			# Debian 9
			if [[ "$VERSION_ID" = 'VERSION_ID="9"' ]]; then

			sudo tee -a /etc/apt/sources.list.d/pritunl.list << EOF
			deb http://repo.pritunl.com/stable/apt stretch main
			EOF

			sudo apt-get install dirmngr
			sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
			sudo apt-get update
			sudo apt-get --assume-yes install pritunl mongodb-server
			sudo systemctl start mongodb pritunl
			sudo systemctl enable mongodb pritunl

			cd
			apt-get -y install squid

			echo ""
			echo "กรุณาตั้งชื่อโฮสเนมพร็อกซี่ของคุณ"
			read -p "Enter Your Proxry Hostname : " Hostname

			cat > /etc/squid/squid.conf <<END
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
			coredump_dir /var/spool/squid
			refresh_pattern ^ftp: 1440 20% 10080
			refresh_pattern ^gopher: 1440 0% 1440
			refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
			refresh_pattern . 0 20% 4320
			visible_hostname $Hostname
			END
			sed -i $MYIP2 /etc/squid/squid.conf;
			/etc/init.d/squid restart

			fi

			# Ubuntu 14.04
			if [[ "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then

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

			cd
			apt-get -y install squid3

			echo ""
			echo "กรุณาตั้งชื่อโฮสเนมพร็อกซี่ของคุณ"
			read -p "Enter Your Proxry Hostname : " Hostname

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
			visible_hostname $Hostname
			END
			sed -i $MYIP2 /etc/squid3/squid.conf;
			/etc/init.d/squid3 restart

			fi

			# Ubuntu 16.04
			if [[ "$VERSION_ID" = 'VERSION_ID="16.04"' ]]; then

			sudo tee -a /etc/apt/sources.list.d/mongodb-org-3.6.list << EOF
			deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse
			EOF

			sudo tee -a /etc/apt/sources.list.d/pritunl.list << EOF
			deb http://repo.pritunl.com/stable/apt xenial main
			EOF

			sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
			sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
			sudo apt-get update
			sudo apt-get --assume-yes install pritunl mongodb-org
			sudo systemctl start pritunl mongod
			sudo systemctl enable pritunl mongod

			cd
			apt-get -y install squid

			echo ""
			echo "กรุณาตั้งชื่อโฮสเนมพร็อกซี่ของคุณ"
			read -p "Enter Your Proxry Hostname : " Hostname

			cat > /etc/squid/squid.conf <<END
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
			coredump_dir /var/spool/squid
			refresh_pattern ^ftp: 1440 20% 10080
			refresh_pattern ^gopher: 1440 0% 1440
			refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
			refresh_pattern . 0 20% 4320
			visible_hostname $Hostname
			END
			sed -i $MYIP2 /etc/squid/squid.conf;
			/etc/init.d/squid restart

			fi

		fi

	else

	cd
	clear
	echo ""
	echo "การติดตั้ง Pritunl รองรับเฉพาะระบบปฏิบัติการด้านล่างนี้"
	echo "Debian 8 - 9"
	echo "Ubuntu 14.04 - 16.04"
	echo ""
	echo "Source by Mnm Ami"
	echo "You can donate via truemoney wallet : 082-038-2600"
	echo ""
	rm AllScript.sh

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

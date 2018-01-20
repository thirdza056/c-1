#!/bin/bash

# Check root
if [[ "$EUID" -ne 0 ]]; then
	echo ""
	echo "กรุณาเข้าสู่ระบบผู้ใช้ root ก่อนทำการติดตั้งสคริปท์"
	echo "คำสั่งเข้าสู่ระบบผู้ใช้ root คือ sudo -i"
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
			fi
		fi

	elif [[ -e /etc/centos-release ]]; then
		OS=centos
		IPTABLES='/etc/iptables/iptables.rules'
		SYSCTL='/etc/sysctl.conf'

		if [[ "$OS" = 'centos' ]]; then

			# CentOS 7
			sudo tee -a /etc/yum.repos.d/mongodb-org-3.4.repo << EOF
			[mongodb-org-3.6]
			name=MongoDB Repository
			baseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/3.6/x86_64/
			gpgcheck=1
			enabled=1
			gpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc
			EOF

			sudo tee -a /etc/yum.repos.d/pritunl.repo << EOF
			[pritunl]
			name=Pritunl Repository
			baseurl=https://repo.pritunl.com/stable/yum/centos/7/
			gpgcheck=1
			enabled=1
			EOF

			sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
			gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
			gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A > key.tmp; sudo rpm --import key.tmp; rm -f key.tmp
			sudo yum -y install pritunl mongodb-org
			sudo systemctl start mongod pritunl
			sudo systemctl enable mongod pritunl

			yum -y install squid
			systemctl restart squid
		fi

	else
		cd
		clear
		echo ""
		echo "การติดตั้ง Pritunl รองรับเฉพาะระบบปฏิบัติการด้านล่างนี้"
		echo "Debian 8 - 9"
		echo "Ubuntu 14.04 - 16.04"
		echo "CentOS 7"
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

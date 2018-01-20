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

			fi

			# Debian 9
			if [[ "$VERSION_ID" = 'VERSION_ID="9"' ]]; then

			cat > /etc/apt/sources.list.d/pritunl.list <<END
			deb http://repo.pritunl.com/stable/apt stretch main
			END
			sudo apt-get install dirmngr
			sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
			sudo apt-get update
			sudo apt-get --assume-yes install pritunl mongodb-server
			sudo systemctl start mongodb pritunl
			sudo systemctl enable mongodb pritunl

			while [[ $CONTINUE != "1" && $CONTINUE != "2" ]]; do

				echo ""
				echo "คุณต้องการติดตั้ง Squid Proxy หรือไม่ ?"
				read -p "You Need Install Squid Proxy or Not ? :" -e -i 1 CONTINUE

			done

				if [[ "$CONTINUE" = "1" ]]; then
				echo "ติดตั้งแล้ว"

				elif [[ "$CONTINUE" = "2" ]]; then
				echo "ยังไม่ติดตั้ง"

				fi

			fi

			# Ubuntu 14.04
			if [[ "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then

			fi

			# Ubuntu 16.04
			if [[ "$VERSION_ID" = 'VERSION_ID="16.04"' ]]; then

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

#!/bin/bash

# Check root
if [[ "$EUID" -ne 0 ]]; then
echo ""
echo "     กรุณาเข้าสู่ระบบผู้ใช้ root ก่อนทำการติดตั้งสคริปท์..."
echo "     คำสั่งเข้าสู่ระบบผู้ใช้ root คือ sudo -i"
echo ""
fi

clear

# Color
color1='\e[031;1m'
color3='\e[0m'

# Menu Function
echo ""
echo -e "${color1}  (\_(\  ${color3}"
echo -e "${color1} (=’ :’) :* ${color3} Script by Mnm Ami"
echo -e "${color1}  (,(”)(”) °.¸¸.• ${color3} บริจาคกันได้ที่ทรูมันนี่วอลเลต 082-038-2600"
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
echo "...."

elif test $x -eq 2; then

	if [[ -e /etc/debian_version ]]; then
		OS="debian"
		VERSION_ID=$(cat /etc/os-release | grep "VERSION_ID")
		IPTABLES='/etc/iptables/iptables.rules'
		SYSCTL='/etc/sysctl.conf'

		if [[ "$OS" = 'debian' ]]; then

			# Debian 7
			if [[ "$VERSION_ID" = 'VERSION_ID="7"' ]]; then
				echo "7"
		
			# Debian 8
			elif [[ "$VERSION_ID" = 'VERSION_ID="8"' ]]; then
				echo "8"

			# Ubuntu 14.04
			elif [[ "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
				echo "14.04"

			# Ubuntu 16.04
			elif [[ "$VERSION_ID" = 'VERSION_ID="16.04"' ]]; then
				echo "16.04"

			else
				clear
				echo ""
				echo "`•.¸¸.•´´¯`•• .¸¸.•´¯`•.•●•۰• ••.•´¯`•.•• ••.•´¯`•.••—"
				echo "     สคริปท์นี้รองรับเฉพาะ Debian 7 - 8 และ Ubuntu 14.04 - 16.04 เท่านั้น"
				echo ""
				echo "     Source by Mnm Ami"
				echo "     You can donate via truemoney wallet : 082-038-2600"
				echo "`•.¸¸.•´´¯`•• .¸¸.•´¯`•.•●•۰• ••.•´¯`•.•• ••.•´¯`•.••—"
				echo ""
				rm Pritunl.sh
			fi
		fi
	fi

elif test $x -eq 3; then
echo "...."

elif test $x -eq 4; then
echo "...."

elif test $x -eq 5; then
echo "...."

elif test $x -eq 6; then
echo "...."

else
clear
./AllScript.sh

fi

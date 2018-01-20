#!/bin/bash

newclient () {
	# Generates the custom client.ovpn
	cp /etc/openvpn/client-common.txt ~/$1.ovpn
	echo "<ca>" >> ~/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/ca.crt >> ~/$1.ovpn
	echo "</ca>" >> ~/$1.ovpn
	echo "<cert>" >> ~/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/issued/$1.crt >> ~/$1.ovpn
	echo "</cert>" >> ~/$1.ovpn
	echo "<key>" >> ~/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/private/$1.key >> ~/$1.ovpn
	echo "</key>" >> ~/$1.ovpn
	echo "<tls-auth>" >> ~/$1.ovpn
	cat /etc/openvpn/ta.key >> ~/$1.ovpn
	echo "</tls-auth>" >> ~/$1.ovpn
}

echo -e "|${color1}1${color3}| ยกเลิก"
echo -e ""
read -p "กรุณาเลือกหัวข้อที่ต้องการใช้งาน (ตัวเลข)  : " x

if test $x -eq 1; then

echo "Please, use one word only, no special characters"
read -p "Client name: " -e -i client CLIENT
cd /etc/openvpn/easy-rsa/
./easyrsa build-client-full $CLIENT nopass

newclient "$CLIENT"
echo ""
echo "Client $CLIENT added, configuration is available at" ~/"$CLIENT.ovpn"
exit

else
exit

fi

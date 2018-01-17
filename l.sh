#!/bin/bash

if [[ -e /etc/lsb-release ]]; then
	OS=ubuntu
     echo "16.04........."
elif [[ -e /etc/centos-release || -e /etc/redhat-release ]]; then
	OS=centos
	RCLOCAL='/etc/rc.d/rc.local'
	chmod +x /etc/rc.d/rc.local
else
	echo "คำสั่งนี้ยังไม่รองรับระบบปฏิบัติการอื่นนอกจาก Debian, Ubuntu และ CentOS"
	exit
fi

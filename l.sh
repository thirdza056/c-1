#!/bin/bash

while [[ $CONTINUE != "1" && $CONTINUE != "2" ]]; do

	echo ""
	echo "คุณต้องการติดตั้ง Squid Proxy หรือไม่ ?"
	read -p "You Need Install Squid Proxy or Not ? :" -e -i 1 CONTINUE

done

if [[ "$CONTINUE" = "2" ]]; then
	echo "บายยย"
        exit
fi

echo "1 ไม่บาย"

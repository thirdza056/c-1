#!/bin/bash

if [[ -e /etc/debian_version ]]; then
        OS="debian"
	VERSION_ID=$(cat /etc/os-release | grep "VERSION_ID")
	IPTABLES='/etc/iptables/iptables.rules'
	SYSCTL='/etc/sysctl.conf'

    if [[ "$OS" = 'debian' ]]; then

		# Debian 7
		if [[ "$VERSION_ID" = 'VERSION_ID="7"' ]]; then
			echo "7"
		fi
		
		# Debian 8
		if [[ "$VERSION_ID" = 'VERSION_ID="8"' ]]; then
			echo "8"
		fi

		# Ubuntu 14.04
		if [[ "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
			echo "14.04"
		fi
		
		# Ubuntu 16.04
		if [[ "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
			echo "16.04"
		fi
    fi
fi

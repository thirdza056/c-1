#!/bin/bash

if [[ "$OS" = 'debian' ]]; then

		# Debian 7
		if [[ "$VERSION_ID" = 'VERSION_ID="7"' ]]; then
			echo "7"
		fi
		# Debian 8
		if [[ "$VERSION_ID" = 'VERSION_ID="8"' ]]; then
			echo "8"
		fi

elif [[ "$OS" = 'ubuntu' ]]; then

		# Ubuntu 14.04
		if [[ "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
			echo "14.04"
		fi
		# Ubuntu 16.04
		if [[ "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
			echo "16.04"
		fi
fi

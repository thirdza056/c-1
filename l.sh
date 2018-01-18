#!/bin/bash

while [[ $CONTINUE != "y" && $CONTINUE != "n" ]]; do
			read -p "Continue ? [y/n]: " -e CONTINUE
		done

		if [[ "$CONTINUE" = "n" ]]; then
			echo "Ok, bye !"
			exit
		fi

echo "====+++==+"

exit

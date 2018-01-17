#!/bin/bash

. /etc/*-release
VERSION_ID=dist

if [ "$dist" == "8" ]; then
  echo "8"
elif [ "$dist" == "14.04" ]; then
  echo "14"
elif [ "$dist" == "16.04" ]; then
  echo "16"
else
echo "0000"
fi

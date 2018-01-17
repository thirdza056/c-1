#!/bin/bash

dist=`grep VERSION_ID /etc/*-release | awk -F '=' '{print $2}'`

if [ "$dist" == "8" ]; then
  echo "8"
elif [ "$dist" == "14.04" ]; then
  echo "14"
elif [ "$dist" == "16.04" ]; then
  echo "16"
else
echo "0000"
fi

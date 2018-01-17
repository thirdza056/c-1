#!/bin/bash

dist=`grep Codename lsb_release -c | awk -F '=' '{print $2}'`

if [ "$dist" == "jessie" ]; then
  echo "8"
elif [ "$dist" == "trusty" ]; then
  echo "14"
elif [ "$dist" == "xenial" ]; then
  echo "16"
else
echo "0000"
fi

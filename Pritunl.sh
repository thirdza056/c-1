#!/bin/bash

dist=`grep DISTRIB_CODENAME /etc/*-release | awk -F '=' '{print $2}'`

if [ "$dist" == "jessie" ]; then
  echo "8"
elif [ "$dist" == "trusty" ]; then
  echo "14"
elif [ "$dist" == "xenial" ]; then
  echo "16"
fi

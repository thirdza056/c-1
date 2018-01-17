#!/bin/bash

. /etc/lsb-release

if [[ ${DISTRIB_CODENAME} == "trusty" ]]; then
    echo "=== 14.04"
    
elif [[ ${DISTRIB_CODENAME} == "xenial" ]]; then
    echo "=== 16.04"
    
elif [[ ${DISTRIB_CODENAME} == "jessie" ]]; then
    echo "=== 8"
    
else
    echo "พัง...!!"
    
fi

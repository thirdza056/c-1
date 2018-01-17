#!/bin/bash

if [[ ${DISTRIB_CODENAME} == "trusty" ]]; then
    echo "=== 14.04"
    exit
    
elif [[ ${DISTRIB_CODENAME} == "xenial" ]]; then
    echo "=== 16.04"
    exit
    
elif [[ ${DISTRIB_CODENAME} == "jessie" ]]; then
    echo "=== 8"
    exit
    
fi

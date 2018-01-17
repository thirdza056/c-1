#!/bin/bash

. /etc/*-release
$version=VERSION_ID
if(!($version -eq "16.04"))
   echo "16"
elif(!($version -eq "14.04"))
   echo "16"
elif(!($version -eq "8"))
   echo "16"
else    
   echo "...."
fi

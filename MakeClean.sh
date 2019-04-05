#!/bin/bash

find ../ -name ".DS_Store" -depth -exec rm {} \;

echo "Cleaning..."
make clean

rm -rf obj
# rm -rf packages
rm -rf .theos
# rm -rf alphachangetextpref/.theos
echo "Cleaning done."

echo "Building..."
# FINALPACKAGE=1
make package install

RED=`tput setaf 1`
NC=`tput sgr0`
CURRENTDATE=`date +"%Y-%m-%d %T"`
echo "Building done." ${RED}${CURRENTDATE}${NC}

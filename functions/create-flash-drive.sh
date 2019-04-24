#!/usr/bin/env bash


function printHelp(){
   echo "Usage:"
   echo "  " $0 "<location/name.img> <size in kB>"
}


if [ $# -ne 2 ]
  then
   echo $#
   printHelp
   exit 1
fi
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

FILE_LOCATION=$1
SIZE=$2

# FILE_LOCATION="/home/pi/usb-drive1.img"
# size="1024"

dd if=/dev/zero of=$FILE_LOCATION bs=1024 count=$SIZE
mkdosfs $FILE_LOCATION
#!/usr/bin/env bash


function printHelp(){
   echo "Usage:"
   echo "  " $0 "<device-name/location-name>"
}


if [ $# -ne 1 ]
  then
   echo $#
   printHelp
   exit 1
fi
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

DEVICE_NAME=$1

#DEVICE_NAME="penpi"


cd /sys/kernel/config/usb_gadget/
mkdir -p $DEVICE_NAME
cd $DEVICE_NAME

ls /sys/class/udc > UDC
#echo test > UDC

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

# Disabling the gadget
echo "" > UDC

#Remove functions from configurations:
rm -f configs/*/*
   # it is normal for it to complain about strngs being a folder
   # it must happen so that folder are removed in the correct order
   # we cant delete it in this step, in next steps we do it

#Remove strings directories in configurations
rm -rf configs/*/strings/*


# and remove the configurations
rm -rf configs/*


#Remove functions (function modules are not unloaded, though)
rm -rf functions/*

#Remove strings directories in the gadget

rm -rf strings/*

#and finally remove the gadget:
cd ..
rm -rf $DEVICE_NAME



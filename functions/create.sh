#!/usr/bin/env bash


function printHelp(){
   echo "Usage:"
   echo "  " $0 "<device-name/location-name> <serial #> <manufacturer> <product name>"
}


if [ $# -ne 4 ]
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
SEARIAL_NUMBER=$2
MANUFACTURER=$3
PRODUCT_NAME=$4

#DEVICE_NAME="penpi"
#SEARIAL_NUMBER="fedcba9876543210"
#MANUFACTURER="PenPi"
#PRODUCT_NAME="PenPi USB"


cd /sys/kernel/config/usb_gadget/
mkdir -p $DEVICE_NAME
cd $DEVICE_NAME
echo 0x1d6b > idVendor # Linux Foundation
echo 0x0104 > idProduct # Multifunction Composite Gadget
echo 0x0100 > bcdDevice # v1.0.0
echo 0x0200 > bcdUSB # USB2
mkdir -p strings/0x409

echo $SEARIAL_NUMBER > strings/0x409/serialnumber
echo $MANUFACTURER > strings/0x409/manufacturer
echo $PRODUCT_NAME > strings/0x409/product
mkdir -p configs/c.1/strings/0x409
echo "Config 1: Main Config" > configs/c.1/strings/0x409/configuration
echo 250 > configs/c.1/MaxPower


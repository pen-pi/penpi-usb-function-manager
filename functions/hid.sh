#!/usr/bin/env bash

function printHelp(){
   echo "Usage:"
   echo "  " $0 "<device-name/location-name> <instance name>"
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

DEVICE_NAME=$1
INSTANCE_NAME=$2

#DEVICE_NAME="penpi"
#INSTANCE_NAME="usb0"

cd /sys/kernel/config/usb_gadget/
mkdir -p $DEVICE_NAME
cd $DEVICE_NAME

mkdir -p functions/hid.$INSTANCE_NAME

echo 1 > functions/hid.$INSTANCE_NAME/protocol
echo 1 > functions/hid.$INSTANCE_NAME/subclass
echo 8 > functions/hid.$INSTANCE_NAME/report_length
echo -ne \\x05\\x01\\x09\\x06\\xa1\\x01\\x05\\x07\\x19\\xe0\\x29\\xe7\\x15\\x00\\x25\\x01\\x75\\x01\\x95\\x08\\x81\\x02\\x95\\x01\\x75\\x08\\x81\\x03\\x95\\x05\\x75\\x01\\x05\\x08\\x19\\x01\\x29\\x05\\x91\\x02\\x95\\x01\\x75\\x03\\x91\\x03\\x95\\x06\\x75\\x08\\x15\\x00\\x25\\x65\\x05\\x07\\x19\\x00\\x29\\x65\\x81\\x00\\xc0 > functions/hid.$INSTANCE_NAME/report_desc
ln -s functions/hid.$INSTANCE_NAME configs/c.1/
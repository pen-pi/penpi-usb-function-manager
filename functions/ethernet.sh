#!/usr/bin/env bash


function printHelp(){
   echo "Usage:"
   echo "  " $0 "<device-name/location-name> <usb interface name> <PenPi MAC> <taget MAC>"
   echo "forst octet of the first byte of the MAC addresses must be even."
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
INTERFACE_NAME=$2
SELF=$3 # penpi MAC
HOST=$4 # taget MAC


#DEVICE_NAME="penpi"
#INTERFACE_NAME="usb0"
#HOST="48:6f:73:74:50:45" # target pc mac
#SELF="42:61:64:55:53:47" # penpi mac


#cd /sys/kernel/config/usb_gadget/
mkdir -p $DEVICE_NAME
cd $DEVICE_NAME

mkdir -p functions/ecm.$INTERFACE_NAME
# first byte of address must be even

echo $HOST > functions/ecm.$INTERFACE_NAME/host_addr
echo $SELF > functions/ecm.$INTERFACE_NAME/dev_addr
ln -s functions/ecm.$INTERFACE_NAME configs/c.1/


# post-function enable , done by other scripts 
# ifconfig $INTERFACE_NAME 10.0.0.1 netmask 255.255.255.252 up
# route add -net default gw 10.0.0.2
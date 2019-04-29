#!/usr/bin/env bash


function printHelp(){
   echo "Usage:"
   echo "  " $0 "<device-name/location-name> <location/name.img> <USB interface> <cd-rom> <read only>"
   echo "first octet of the first byte of the MAC addresses must be even."
}


if [ $# -ne 5 ]
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
FILE=$2
INTERFACE_NAME=$3
CDROM=$4
RO=$5


#DEVICE_NAME="penpi"
#FILE=/home/pi/usbdisk1.img
#INTERFACE_NAME="usb0"
#CDROM="0"
#RO="0"


cd /sys/kernel/config/usb_gadget/
mkdir -p $DEVICE_NAME
cd $DEVICE_NAME


mkdir -p ${FILE/img/d}
mount -o loop,ro, -t vfat $FILE ${FILE/img/d} # FOR IMAGE CREATED WITH DD
mkdir -p functions/mass_storage.$INTERFACE_NAME
echo 1 > functions/mass_storage.$INTERFACE_NAME/stall
echo $CDROM > functions/mass_storage.$INTERFACE_NAME/lun.0/cdrom
echo $RO > functions/mass_storage.$INTERFACE_NAME/lun.0/ro
echo 0 > functions/mass_storage.$INTERFACE_NAME/lun.0/nofua
echo $FILE > functions/mass_storage.$INTERFACE_NAME/lun.0/file
ln -s functions/mass_storage.$INTERFACE_NAME configs/c.1/
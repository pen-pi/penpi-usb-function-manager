function printHelp(){
   echo "Usage:"
   echo "  " $0 "<device-name/location-name> <file.iso> <USB interface>"
   echo "first octet of the first byte of the MAC addresses must be even."
}


if [ $# -ne 3 ]
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



#DEVICE_NAME="penpi"
#FILE=/home/pi/usbdisk1.img
#INTERFACE_NAME="usb0"
#CDROM="0"
#RO="0"


cd /sys/kernel/config/usb_gadget/
mkdir -p $DEVICE_NAME
cd $DEVICE_NAME


#FILE=/home/pi/gparted.iso
mkdir $FILE.d
mount -o loop,ro, $FILE $FILE.d
mkdir -p functions/mass_storage.$INTERFACE_NAME
echo 1 > functions/mass_storage.$INTERFACE_NAME/stall
echo 0 > functions/mass_storage.$INTERFACE_NAME/lun.0/cdrom
echo 0 > functions/mass_storage.$INTERFACE_NAME/lun.0/ro
echo 0 > functions/mass_storage.$INTERFACE_NAME/lun.0/nofua
echo $FILE > functions/mass_storage.$INTERFACE_NAME/lun.0/file
ln -s functions/mass_storage.$INTERFACE_NAME configs/c.1/
#ls /sys/class/udc > UDC

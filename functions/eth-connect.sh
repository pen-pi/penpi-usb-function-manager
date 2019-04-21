#!/usr/bin/env bash


function printHelp(){
   echo "Usage:"
   echo "  " $0 "<usb interface name>"
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

INTERFACE_NAME=$1

#INTERFACE_NAME="usb0"

ifconfig $INTERFACE_NAME 10.0.0.1 netmask 255.255.255.252 up

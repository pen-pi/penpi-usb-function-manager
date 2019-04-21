# Functions

The scripts located inside the `functions` folder are the core of this library.    
The python script will use these scripts to make, configure and delete the virtual device from the PenPi.   

# Usage

Must me run as root

## As bash

Each script has its own help menu. 
1. Create device: run `functions/create.sh` 

### Variables

#### `<device-name/location-name>`
This is the name of the folder where the USB device will be created inside of `/sys/kernel/config/usb_gadget/`. It is also the name of the gadget. This field must be used consistently throughout all the scripts, otherwise scripts won't modify the correct device.   

Note: name must be valid Linux folder name.   
Example: `penpi`   

#### `<serial #>`
This is the serial for the PenPi USB, it should be unique for every PenPi out in the world.    

Example: `fedcba9876543210`    

#### `<manufacturer>` 
This is the manufacturer's name. This is for USB related purposes. If it contains spaces then it must encapsulated in quotes so program considers as one argument.   

Example: `"PenPi Organization"`   

#### `<product name>`

This is the name of the product as a USB, this name is the name that shows up in the list of plugged in devices. If it contains spaces then it must encapsulated in quotes so program considers as one argument.   

Example: `"PenPi USB"`   

#### HID Variables
##### `<instance name>`
This is the name of the HID device within the USB gadget. This field must be unique for every HID created. It is recommended to just create one and name it `usb0`.   

Example: `usb0`   

#### Network Card Variables

Some of the variables can match some of the previous defined variables. Just remember that they must not match withing this same category. For Example if defining multiple network cards they must not have the same names but it is okay for one of them to have the same as HID device since they don't conflict.   


#### `<usb interface name>` 
This is the name of the device of the function inside of the USB gadget. This should be unique for every network card that needs to be created within a single PenPi unit. It need to be a valid Linux folder name. prefered name convention `usbX`, where `X` is an integer. In theory this should end up being the name the operating system gives to the network interface, but don't quote me on this.   

Example: `usb0`   

##### `<PenPi MAC>`
This is the MAC address that will be assigned to the network interface on the PenPi side of the connection. This Address need to be unique for every network interface and PenPi. The Address doesn't have to be encapsulated in quotes but is preferred.    

Note: The first octet of the MAC must be even.      
Example: `"42:61:64:55:53:47"`   

##### `<target MAC>`
This is the MAC address that will be assigned to the network interface on the Target side of the connection. This Address need to be unique for every network interface and PenPi. The Address doesn't have to be encapsulated in quotes but is preferred.    

Note: The first octet of the MAC must be even.   
Example: `"48:6f:73:74:50:45"`   



## As Python Lib

To be Implemented

# TODO

- implement USB storage creation scripts
   - make drive
   - delete drive
   - USB gadget funtion - PenPi function
- make python wrapper library for functions

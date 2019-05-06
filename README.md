# Functions

The scripts located inside the `functions` folder are the core of this library.    
The python script will use these scripts to make, configure and delete the virtual device from the PenPi. With help of libPenPi we can stack more functionally to hard to manage usb resources. This allows us to implements more functionally on top of this, which eneble us to do things like remote configuration via wifi and bluetooth.      

# Usage

Must me run as root

## As bash

Each script has its own help menu. Please refer to each scripts help menu for usage. Use this a guide as extra help    
Run each script in this order, making sure to input the corresponding arguments as needed.   

1. Create device: run `functions/create.sh`    
2. Run `HID`, `ethernet`, and `mass_storage` as needed. Each will setup PenPi for their respective actions   
3. Enable device by running `functions/on.sh`   
4. If needed by a module run the post scripts for that module. For example `ethernet` benefits from `eth-connect` and `eth-default` and so on   

In the event that more functionality is required later:
1. Stop device by running `functions/off.sh`    
2. Delete current device with `functions/remove.sh`   
3. Redefine device using the previous list of steps   

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
This is the name of the device of the function inside of the USB gadget. This should be unique for every network card that needs to be created within a single PenPi unit. It need to be a valid Linux folder name. preferred name convention `usbX`, where `X` is an integer. In theory this should end up being the name the operating system gives to the network interface, but don't quote me on this.   

Example: `usb0`   

##### `<PenPi MAC>`
This is the MAC address that will be assigned to the network interface on the PenPi side of the connection. This Address need to be unique for every network interface and PenPi. The Address doesn't have to be encapsulated in quotes but is preferred.    

Note: The first octet of the MAC must be even.      
Example: `"42:61:64:55:53:47"`   

##### `<target MAC>`
This is the MAC address that will be assigned to the network interface on the Target side of the connection. This Address need to be unique for every network interface and PenPi. The Address doesn't have to be encapsulated in quotes but is preferred.    

Note: The first octet of the MAC must be even.   
Example: `"48:6f:73:74:50:45"`   




#### Mass Storage Variables

This provides mass storage and CD-ROM capabilities.   

Some of the variables can match some of the previous defined variables. Just remember that they must not match withing this same category. For Example if defining mass torage devices they must not have the same names but it is okay for one of them to have the same as HID device since they don't conflict.   


#### `<location/name.img>` 
This is the location where the mass storage image will be created at. Use the same location when using other commands. This is unique for every mass storage that need to be created.   

Example: `/home/pi/usb-drive1.img`    

##### `<size in kB>`
This is the size of the `<location/name.img>` in kilobytes.   

Example: `1024`   

##### `<USB interface>`
This is the name of the device of the function inside of the USB gadget. This should be unique for every mass storage that needs to be created within a single PenPi unit. It need to be a valid Linux folder name. preferred name convention `usbX`, where `X` is an integer.    

Example: `usb0`   

##### `<cd-rom>`
This determines whether the mass storage should be mounted as a flash drive or as a CD-ROM. It only has two possible values: `0` or `1`.   

Example: `1`   

##### `<read only>`
This determines if the mass storage should be read only. It only has two possible values: `0` or `1`. If mounted as CD-ROM then it will defaults to read only and can not be overwritten, the value should still be specified.   

Example: `0`   



## As Python LibPenPi
LibPenPi is the heart of the PenPi project as later iterations of the project are committed libpenpi will replace outdated static scripts to initialize the device. This library will allow different kinds of integrations like remote management of the core components of PenPi. 

#### `up()`
This function should be called to bring the device up. Should be done after creating/initializing it and adding the necessary functions (see [Functions](#Funtions) section). It is important to note that the functions will only be enabled whenever the device is up.   

#### `down()`
This Function will bring the device down. This is is required when trying to add or remove functions from PenPi core functionalities.

### Initializers and Destructors
It is required to initialize PenPi before adding functions and bringing the device up. It is also required to brnig the device down to modify its functions.

#### `__init__(devName="penpi", manuf="PenPi", prodName="PenPi USB", serial="abcdef0123456789")`
Default and only constructor for PenPi object. It will create an instance of the PenPi management core. This function will not initialize/create the device.

##### Input
###### devName
Device name. This should be a valid folder name in Linux. This is not the name that shows in the USB protocol. This name is for internal use.
###### manuf
This is the name that will show as manufacturer when connecting device to a host. This is the manufacturer that will show in the USB protocol.
###### prodName
This is the name of the product. This will show in the USB connection and device description on the host device. 

###### serial
This is the serial number of the device. This in theory should be unique for every PenPi but the same every time for each device. For security the serial can be set to be random using the random serial generator function `randSerial()`.

#### `init()`
This function is purely for internal use only. Used for initialization purposes only.

#### `create()`
This function is the one who initializes the PenPi. It creates the folder structure necessary to create any further functions. Remember to call this once after creating a PenPi instance or after calling the `remove` method. This function call is required before calling any of the functions detailed in the [Functions](#Funtions) section.

#### `delete()`
This function will delete the folder structure and uninitialize the PenPi instance. This means this is the clean up method for the instance.This will remove everything, will leave instance in the same state as when creating the instance. Call this when it is required to add new functionality, keep in mind that you must redefine everything that was previously defined (disk creating is not required because those are save in disk). If you want re use this class you must initialize again.

### Functions
PenPi instance must be initialized/created, otherwise will return `False`. Some require special conditions to be met before they are allowed to work. Please look at each function for further information.   

#### `enebleHID()`
This will enable the HID keyboard functionality in the PenPi. There can only exists one instance of this function in PenPi. This network interface is effectively a connection between the PenPi and the target machine where PenPi was physically connected to. 

#### `enebleNetworkCard(hostMAC, targetMAC)`
This will enable the network adapter in the PenPi. In theory PenPi can support multiple number of network interfaces, this only gives you one (with max of 1 for now).
##### Input
###### hostMAC
This is the MAC of the PenPi for this interface.
###### targetMAC
This is the MAC of the target machine for this interface.

#### `enebleNetworkCardRand()`
Same as `enebleNetworkCard(hostMAC, targetMAC)` but this one the MAC addresses are randomized.

#### `networkCardConnect()`
#### `networkCardAddDefaultRoute()`
#### `createMassStorage(location, size=1024)`
#### `mountMassStorage(location, ro=False, CDROM=False)`
#### `mountISO(isoFile)`

### Other Functions
#### `deleteAnyDev(devName)`
#### `randSerial()`
#### `randMAC()`




# TODO

- [x] implement USB storage creation scripts
   - [x] make drive
   - [x] delete drive
   - [x] USB gadget function - PenPi function
- [x] make python wrapper library for functions

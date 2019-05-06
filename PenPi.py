#!/usr/bin/env python2

#import abc
import subprocess
import os
from random import *


#######################################################
###############  Class Variables  #####################
#######################################################

scripts_location = "./functions"  



#######################################################
################  Helper Functions  ###################
#######################################################

hexChars = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]
def genOctect(even=False):
   partA = hexChars[randint(0,15)]
   if even:
      partB = hexChars[(randint(0,15)*2)%16]
   else:
      partB = hexChars[randint(0,15)]
   return partA + partB

def randMAC():
   return genOctect(even=False)+':'+genOctect()+':'+genOctect()+':'+genOctect()+':'+genOctect()+':'+genOctect()

def randSerial():
   serial = ""
   for x in range(0, 15): # 16 times 
      serial = serial + hexChars[randint(0,15)]
   return serial
   
#######################################################
#################  PenPi Class  #######################
#######################################################

class Penpi:
   #location = "/sys/kernel/config/usb_gadget/"
   deviceName = "penpi" 
   deviceSerial = "abcdef0123456789"
   manufacturer = "PenPi"
   productName = "PenPi USB"
   initialized  = False
   deviceOn = False

   hidEnabled = False
   networkCardEnabled = False
   mountedLocations = []
   nextInterdaceUSB = 0

   def __init__(self, devName="penpi", manuf="PenPi", prodName="PenPi USB", serial="abcdef0123456789"):
      self.deviceName = devName 
      self.deviceSerial = serial
      self.manufacturer = manuf
      self.productName = prodName
      self.init()


   def __del__(self):
      self.delete()
   
   def init(self):
      self.initialized  = False
      self.deviceOn = False
      self.hidEnabled = False
      self.networkCardEnabled = False
      self.mountedLocations = []
      self.nextInterdaceUSB = 0

   def create(self):
      if not self.initialized:
         cmd = scripts_location+'/create.sh ' + self.deviceSerial +' "'+self.manufacturer+ '" "'+self.productName+'"'  
         os.system(cmd)
         self.initialized = True
         # TODO check if it worked, return accordingly
         return True
      else:
         return False
   def up():
      if not self.deviceOn: # if down
         cmd = scripts_location+'/on.sh "' + deviceName + '"'
         os.system(cmd)
         self.deviceOn = True
         # TODO check if it worked, return accordingly
         return True
      else:
         return False
   def down(self):
      if self.deviceOn:
         cmd = scripts_location+'/off.sh "' + deviceName + '"'
         os.system(cmd)
         self.deviceOn = False
         # TODO check if it worked, return accordingly
         return True
      else:
         return False
   
   def delete(self):
      if self.initialized:
         self.deleteAnyDev(self.deleteAnyDev(self.deviceName))
         self.init()
         return True
      else:
         return False
   def deleteAnyDev(self, devName):
      cmd = scripts_location+'/remove.sh "' + devName + '"'
      os.system(cmd)
      if devName == self.deviceName and self.initialized:
         self.initialized = False
      
   def enebleHID(self):
      if self.initialized and self.hidEnabled:
         cmd = scripts_location+'/hid.sh "'+self.deviceName+'" usb0'
         os.system(cmd)
         self.hidEnabled = True
         # TODO check if it worked, return accordingly
         return True
      else:
         return False

   def enebleNetworkCard(self, hostMAC, targetMAC):
      if self.initialized and not self.networkCardEnabled:
         cmd = scripts_location+'/ethernet.sh "'+self.deviceName+'" usb0 ' + hostMAC + ' '+ targetMAC 
         os.system(cmd)
         self.networkCardEnabled = True
         # TODO check if it worked, return accordingly
         return True
      else:
         return False
   def enebleNetworkCardRand(self, hostMAC, targetMAC):
      return self.enebleNetworkCardRand(self, randMAC(), randMAC())

   def networkCardConnect():
      if self.initialized and self.networkCardEnabled:
         cmd = scripts_location+'/eth-connect.sh usb0'
         os.system(cmd)
         # TODO check if it worked, return accordingly
         return True
      else:
         return False
   def networkCardAddDefaultRoute():
      if self.initialized and self.networkCardEnabled:
         cmd = scripts_location+'/eth-default.sh usb0'
         os.system(cmd)
         # TODO check if it worked, return accordingly
         return True
      else:
         return False

   def createMassStorage(self, location, size=1024): # size in kB
      #remember to create only once
      if  not os.path.exists(location)
         cmd = scripts_location+'/create-flash-drive.sh '+ location+ ' ' + str(size) 
         os.system(cmd)
         # TODO check if it worked, return accordingly
         return True
      else:
         return False

   def mountMassStorage(self, location, ro=False, CDROM=False):
      if ro:
         readOnly='1'
      else:
         readOnly='0'
      if CDROM:
         cdrom = '1'
         readOnly='1'
      else:
         cdrom='0'

      if self.initialized and location not in self.mountedLocations and  os.path.exists(location):
         interface = "usb"+str(self.nextInterdaceUSB)
         cmd = scripts_location+'/mountStorage.sh "'+self.deviceName+'" ' + location + ' '+ interface+" "+ cdrom+' '+readOnly  
         os.system(cmd)
         self.mountedLocations.append(location)
         self.nextInterdaceUSB = self.nextInterdaceUSB + 1
         # TODO check if it worked, return accordingly
         return True
      else:
         return False

   def mountISO(self, isoFile): # works in a similar fashion as the usb storage
      if self.initialized and isoFile not in self.mountedLocations and  os.path.exists(isoFile):
         interface = "usb"+str(self.nextInterdaceUSB)
         cmd = scripts_location+'/mount-iso.sh "'+self.deviceName+'" ' + isoFile + ' '+ interface  
         os.system(cmd)
         self.mountedLocations.append(isoFile)
         self.nextInterdaceUSB = self.nextInterdaceUSB + 1
         # TODO check if it worked, return accordingly
         return True
      else:
         return False

if __name__ == "__main__":
    # execute only if run as a script
    #main()
    pass
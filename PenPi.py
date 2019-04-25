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
   deviceSerial = "fedcba9876545662"
   manufacturer = "PenPi"
   productName = "PenPi USB"
   initialized  = False
   deviceOn = False

   hidEnabled = False
   networkCardEnabled = False


   def __init__(self, devName="penpi", manuf="PenPi", prodName="PenPi USB", serial="fedcba9876545662"):
      self.deviceName = devName 
      self.deviceSerial = serial
      self.manufacturer = manuf
      self.productName = prodName
      self.initialized  = False
      self.deviceOn = False
      self.hidEnabled = False
      self.networkCardEnabled = False


   def __del__(self):
      self.delete()
      
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
         self.initialized = False
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
         cmd = scripts_location+'/hid.sh "'+self.deviceName+'"" usb0'
         os.system(cmd)
         self.hidEnabled = True
         # TODO check if it worked, return accordingly
         return True
      else:
         return False

   def enebleNetworkCard(self, hostMAC, targetMAC):
      if self.initialized and self.networkCardEnabled:
         cmd = scripts_location+'/ethernet.sh "'+self.deviceName+'"" usb0 ' + hostMAC + ' '+ targetMAC 
         os.system(cmd)
         self.networkCardEnabled = True
         # TODO check if it worked, return accordingly
         return True
      else:
         return False
   def enebleNetworkCard(self, hostMAC, targetMAC):
      return self.enebleNetworkCardRand(self, randMAC(), randMAC())

   



if __name__ == "__main__":
    # execute only if run as a script
    #main()
    pass
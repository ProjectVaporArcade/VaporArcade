#!/usr/bin/python
import argparse
import os
## FILL IN EMULATOR PATH (Absolute)
EmulatorPath = "/Users/Aaron Lindberg/Documents/GitHub/VaporArcade/Emulator/CALC/GuiCalculator.exe"
## FILL IN EMULATOR ARGUMENTS
Arguments = ""
## FILL IN EMULATOR SETTINGS FILE PATH (Absolute)
SettingsFile = ""
 

## Emulator Settings Hash table
settingsHash = dict({})
################################################################################
## AddSetting
## INPUT ##
##  Take a string of the category name, a string of the name of the setting, a
## string of the current value, and a string list of available Settings, and a 
## 1 or 0 to indicate the Input Type Modifier.
## Process ##
##  Add a setting to the emulator settings hash if the setting name does not
## already exist in the emulator settings hash table.
################################################################################
def AddSetting(Category, Name, CurrentSetting, AvailableSettings):
    if Category not in settingsHash:
        settingsHash[Category] = {}
    if Name not in settingsHash[Category]:
        settingsHash[Category][Name] = (CurrentSetting, AvailableSettings)
################################################################################
## UpdateSetting
## INPUT ##
##  Take a string of the category name, a string of the name of the setting, and
## a string of the new current value.
## Process ##
##  Updates the current value of a specific setting in category.
################################################################################
def UpdateSetting (Category, Name, NewValue):
    if Category in settingsHash:
        if Name in settingsHash[Category]:
            settingsHash[Category][Name] = (NewValue, settingsHash[Category][Name][1])

def main():
    parser = argparse.ArgumentParser(description='VBA Emulator and Settings Interface')
    parser.add_argument('-c', metavar='command', dest='command', default='l',## Defaults to load
                       help='Load or Save (l,s) (default is l)')
    parser.add_argument('-t', metavar='type',dest='type', default='l',## Defaults to Launcher
                       help='Launch or Settings (l,s) (default is l)')

    args = parser.parse_args()


    if(args.command[0] == 'l'): # if loading Settings info
        if(args.type[0] == 'l'):
            print("$%$DUMP&LAUNCHERDATA")
            print("EMULATORPATH=" + "\"" + EmulatorPath + "\"")
            print("ARGUMENTS=" +  Arguments )
            print("$&$")
        elif(args.type[0] == 's'):## load settings
            print("$%$DUMP&ALLSETTINGS")
            with open(SettingsFile, 'r') as fin:## Open File For Read
		data = ""
	    	for line in fin:
			if(line.startswith("#")):
				data+=line
			elif (len(line) > 2):
				index = line.replace("\n","").split('=')[0]
				cValue = line.replace("\n","").split('=')[1]
				if index in AvailSettingsList:
					category = AvailSettingsList[index][0]
					name = AvailSettingsList[index][1]
					avail = AvailSettingsList[index][2]
					AddSetting(category, name, cValue, avail)
					data = ""			
	    fin.closed
	    fin.close()
            print(settingsHash)
            print("$&$")
        else:
            print("Invalid Type specified")

    elif(args.command[0] == 's'): #If Saving Settings
        
        print("saving ", args.type) 
    else:
        print("Invalid command Specified!")
main()

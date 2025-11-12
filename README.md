# Penguin-Flasher

This is Penguin Flasher. A simple script I made to make the process of making bootable Linux USBs. I made it as I am usually flashing drives a lot to make a variety of servers and test different distros. This quickly became a pain, so hence this script exists. I hope you can find some use for it. Feel free to contribute, give suggestions to improve, or tell me I am an idiot who is doing it very wrong. I accept all feedback given it's presented without malice. 

## Requirements 
* You must have `dd` installed. if not, install the `coreutils` package from your distros package manager e.g., apt, pacman, rpm, etc.
* You must have a pre-created directory for your iso as this script doesn't make it. I would make one then move your isos there. As this script will keep using the same folder you tell it to use the first time. 



## How it works:

* Prompts for location of ISO folder

* Then lists contents of folder to let you choose what ISO you want to use

* Checks the file to verify it was correctly typed and does in fact exist

* Lists all drives detected by the kernel

* Prompts you to choose a drive. e.g., sda, sdb, etc.

* Verifies the choices you made to make sure that everything is correct.

* Runs dd with the information and starts the flashing process, then alerts you when it has completed

## More detailed version of how it works

When it first runs. It will ask you to give the path of a folder where you will keep your ISO files. Once you provide the path. It will save this to a file in your home directory. That way the next time you run the script. It will then check there. You can then edit the config file directly afterwards to update it in the event you change the folder where files are at. 

It will then list the contents of that folder where you have the ISOs at. It then will list all the devices it detects on your system. Make sure your device is listed. Once found, it will use the drive you chose and the image file to flash. It will let you know once it is done. 

This process uses `ls` to list the contents.

then `lsblk`with some flags to get drive information

then `dd` to flash everything. 


## Possible Issues
* If you are unable to find the config file. it is hidden so us the `-a` flag with ls to look for it. make sure it is only ran with sudo. otherwise the config file may be in root's home, which isn't ideal. plus you shouldn't be running somebody elses script directly as root. always use sudo.
* This is a edge case i haven't tested yet. in the event your device doesn't get flashed. make sure it isn't mounted as this script doesn't auto demount for you. you have to do that yourself as it assumes it is not mounted.

## Ideas for future updates/TODO
* Add demounting feature
* Add feature to relist drives in the event it isn't listed first time and/or unplugged without having to restart whole script.
* Add autocompletion feature
* Add TUI menu to streamline the iso and drive selection procress. 


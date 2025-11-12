#!/bin/bash
#################################################################
## Author: Penguin-Bytes                                       ##
## Description: A script to flash Linux ISOs/Img to USB drives ##
## Version: 1.0                                                ##
#################################################################

## checking the euid, if it's anything but 0, then don't allow it to run
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

## section of vars to be used throughout the script
usr_dir=$(getent passwd ${SUDO_USER:-$USER} | cut -d: -f6)
config_file="$usr_dir/.penguin_flasher.conf"


## first time running section, this is to make the config file and asks the user to write the absolute path of where it's located

if [[ -f "$config_file" ]]; then
    echo "Checked config file...."
else
    echo "Config file not found, Creating it..."
    touch "$config_file"
    echo "# Penguin Flasher Config file" >> "$config_file"
    echo "Config file created! it's located at: '$config_file'"    
fi
source "$config_file"

## checks to see if the image directory exists/has been set, if not asks the user to enter an absolute path

if [[ -z "$iso_dir" ]]; then
    echo "Image directory has not been set"
    while true; do 
        echo "Enter the absoltute path: "    
        read -r iso_dir
        if [[ -d "$iso_dir" ]]; then
            echo "iso_dir=\"$iso_dir\"" >> "$config_file"
            echo "Updated config iso dir to '$iso_dir'"
           break
        else
            echo "Error: '$iso_dir' is not a valid directory, Try again"
        fi
    done
fi

clear

echo -e "Disclaimer: Incorrect use of this tool may result in permanent data loss,\nthe creator of PenguinFlasher takes no responsibility for this, use at your own risk\n"
echo -e "Welcome to the Penguin Flasher!\nThis tool is used to flash Linux ISOs to USB drives\nlet's begin!"


while true; do
    echo "#######Images#########"
    find "$iso_dir" -maxdepth 1 -type f \( -iname "*.iso" -o -iname "*.img" \) -printf "%f\n"
    echo "######################"
    echo "Type the FULL file name that you wish to use to image, has to be exact"
    read -rp "Image choice: " iso_choice
    iso_path="$iso_dir"/"$iso_choice"
    if [[ -f "$iso_path" ]]; then
        echo "File Found: '$iso_path'"
        break
    else
        echo "File can't be found, is it mistyped? Try again."
    fi
done


while true; do
    echo "#######Drives#########"
    lsblk -o NAME,SIZE,MODEL
    echo "######################"
    echo "Type the the extension of the drive you want to use, e.g sda, sdb, etc"
    read -rp "drive_choice: " drv_choice
    drv_path=/dev/"$drv_choice"
    if [[ -b "$drv_path" ]]; then
        echo "Using drive: '$drv_path'"
        break
    else 
        echo "the selected drive:'$drv_path' does not exist"
    fi
done

echo -e "\nStart the imaging process using '$iso_choice' to flash onto '$drv_path'?"
read -rp "Is this correct? (y/n): " final_check
if [[ "$final_check" == "y" || "$final_check" == "Y" ]]; then
    echo "starting..."
else
    echo "Aborting..."
    exit 1
fi

dd if="$iso_path" of="$drv_path" bs=10M status=progress || { 
    echo "Error: Imaging failed!"
    exit 1
}
sync

echo -e "Imaging process completed successfully!\nExiting and syncing..."

#!/bin/bash
# NOTE: This script ONLY WORKS if there's no SD card in the board AND the 
# board has already been flashed with klipper via SD card.
# NEXT SECTION IS ONLY RELEVANT IF USING THE boot0 JUMPER (NOT RECOMMENDED)
# The first time the board is booted after the jumper has been installed
# the board needs to be flashed via the dfu vendor:device id. After that
# it can be flashed via the /dev/btt-octopus-pro-446 path, but it then fails
# to exit dfu mode, and then one needs to flash it yet again with the
# vendor:device id. Then it correctly exits DFU mode. Except those times
# where it doesn't, for that we have a 3rd pass...

if [ "$EUID" -ne 0 ]
  then echo "ERROR: Please run as root"
  exit
fi

MCU=/dev/btt-octopus-pro-446
VENDORDEVICEID=0483:df11
cp -f ~/klipper_config/scripts/btt-octopus-pro-446/normal.config ~/klipper/.config
pushd ~/klipper
make olddefconfig
make clean
make

if [ ! -d "~/klipper_config/firmware_binaries" ]
then
    mkdir ~/klipper_config/firmware_binaries
    chown ubuntu:ubuntu ~/klipper_config/firmware_binaries
fi
cp -f ~/klipper/out/klipper.bin ~/klipper_config/firmware_binaries/firmware-btt-octopus-pro-446.bin
chown ubuntu:ubuntu ~/klipper_config/firmware_binaries/firmware-btt-octopus-pro-446.bin

service klipper stop
if [ -h $MCU ]; then
    echo "Flashing Octopus via path"
    make flash FLASH_DEVICE=$MCU
else
    echo "Flashing Octopus via vendor and device ids - 1st pass"
    make flash FLASH_DEVICE=$VENDORDEVICEID
fi
sleep 5
if [ -h $MCU ]; then
    echo "Flashing Successful!"
else
    echo "Flashing Octopus via vendor and device ids - 2nd pass"
    make flash FLASH_DEVICE=$VENDORDEVICEID

    sleep 5
    if [ -h $MCU ]; then
        echo "Flashing Successful!"
    else
        echo "Flashing Octopus via vendor and device ids - 3rd pass"
        make flash FLASH_DEVICE=$VENDORDEVICEID
        if [ $? -eq 0 ]; then
            echo "Flashing successful!"
        else
            echo "Flashing failed :("
            service klipper start
            popd
            # Reset ownership
            chown ubuntu:ubuntu -R ~/klipper
            exit 1
        fi
    fi
fi
# Reset ownership
chown ubuntu:ubuntu -R ~/klipper
service klipper start
popd

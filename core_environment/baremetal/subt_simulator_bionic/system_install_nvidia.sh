#!/bin/bash

set -e

#Useful info at https://www.linuxbabe.com/ubuntu/install-nvidia-driver-ubuntu-18-04

if lshw -c video | grep "vendor" | grep -q "NVIDIA Corporation"; then
    echo "NVIDIA card detected."
    if lshw -c video | grep "configuration:" | grep -q "driver=nouveau"; then
    	echo "nouveau driver detected. Attempting to install NVIDIA drivers"
    	# Use "ubuntu-drivers devices" to see the available drivers
    	ubuntu-drivers autoinstall

    	echo "Computer may need to be rebooted before some changes take effect."
    	echo "or at least restart X-windows."
    fi	
fi


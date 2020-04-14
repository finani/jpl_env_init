#!/bin/bash

# Based on info from https://ubuntuforums.org/showthread.php?t=2400400

# Update Ubuntu 18.04 to add Vega M (Hades Canyon) graphics support
# Caution: this is a bit risky.  It hasn't bricked anything for me, but then, I play an expert on tv.
# Ideally you'd read this, understand it, and run each step by hand, carefully.
# But it worked first try for me as is.
set -ex
mkdir tmp
cd tmp
# New mesa (ca. 18.1.5) and friends
sudo add-apt-repository ppa:ubuntu-x-swat/updates
sudo apt dist-upgrade        # pulls new mesa from above ppa
# New linux kernel (preview of 4.20)
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v4.20/linux-headers-4.20.0-042000_4.20.0-042000.201812232030_all.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v4.20/linux-headers-4.20.0-042000-generic_4.20.0-042000.201812232030_amd64.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v4.20/linux-image-unsigned-4.20.0-042000-generic_4.20.0-042000.201812232030_amd64.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v4.20/linux-modules-4.20.0-042000-generic_4.20.0-042000.201812232030_amd64.deb

sudo dpkg -i linux-*.deb
# New linux-firmware (will be released as 1.175 or something like that)
wget -m -np https://people.freedesktop.org/~agd5f/radeon_ucode/vegam/
sudo cp people.freedesktop.org/~agd5f/radeon_ucode/vegam/*.bin /lib/firmware/amdgpu
sudo /usr/sbin/update-initramfs -u -k all
cd ..
rm -rf tmp

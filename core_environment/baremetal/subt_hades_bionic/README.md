Upgrade the bios using instructions in IntelBiosUpdate. Without this
step you may occasionally have problems with booting linux from USB
sticks and/or SSDs.


At boot press F2 to enter bios. 

Disable secure boot. Do not enable Fastboot.

Occasionally there are still problems with the USB disk 

# Ubuntu 18.04.1

After powering off, insert a Ubuntu 18.04.1 installation disk in the USB
slot and press F10 during boot to select 

'''
UEFI : USB : SanDisk : PART 0 : OS Bootloader
'''

At the grub prompt select "Install Ubuntu". "Try ubuntu" will not work.

english, english, no wifi, minimal installation

No proprietary drivers needed

Minimal installation

Erase and install ubuntu. 

pick your time zone

costar, costar, costar

After reboot the GUI will not work. you'll have to login to a terminal
and fix things using the stuff in GraphicsFix

# Ubuntu 18.10

After powering off, insert a Ubuntu 18.10 installation disk in the USB
slot and press F10 during boot to select 

'''
UEFI : USB : SanDisk : PART 0 : OS Bootloader
'''

At the grub prompt select "Install Ubuntu". "Try ubuntu" will not work.

english, english, no wifi, minimal installation

No proprietary drivers needed

Minimal installation

Erase and install ubuntu. 

pick your time zone

costar, costar, costar

After reboot everything should just work.


In BIOS set Network boot to UEFI PXE & iSCSI
Ethernet1 boot enabled 

Ethernet1 is closest to the USB ports on the back. This is also the
first mac address on the list on the bottom.

At boot press F10 and select 

UEFI : LAN : PXE IP4 Intel(R) Ethernet Connection (2)

When the fog menu appears, use arrow keys to select

Quick Registration and Inventory

On your laptop (connected via ethernet to the same router) browse to 


http://192.168.5.3/fog/management/index.php?node=task&sub=listhosts

Find the host and rename it to the proper name.

If you're capturing a new image, create a new image for the host,
select the image in the host menu, and select capture from the tasks.

Reboot the hades, press F10, select the network again.

Image captured.

## Deploying on HADES003

At boot press F2

In BIOS set Network boot to UEFI PXE & iSCSI
Ethernet1 boot enabled

Ethernet1 is closest to the USB ports on the back. This is also the
first mac address on the list on the bottom.

At boot press F10 and select 

UEFI : LAN : PXE IP4 Intel(R) Ethernet Connection (2)

When the fog menu appears, use arrow keys to select: "Quick Registration and Inventory"

On your laptop, in the fog host menu find the new host. Rename it and
select the image that you want to deploy to it. Click Update, then go
to the task menu, find the host, and then click deploy.

Reboot the host (HADES003 in this example) and at boot press F10 and again
select the IP4 network boot option.


Alternatively, directly on the HADES device itself, reboot it and press F10 and
select the IV4 network boot option.

When the fog menu appears, use the arrow keys to select: "Deploy Image"
Then, select the image you want to deploy and deploy it. Type in "fog" as the
username and "password" as the password.


The image is deployed and HADES003 successfully booted.

Expand Linux Filesystem

    Make sure you have a backup of your data - since we're going to modify the partition table there's a chance to lose all your data if you make a typo, for example.

    Run sudo fdisk /dev/sda
        use p to list the partitions. Make note of the start cylinder of /dev/sda1
        use d to delete the /dev/sda1 partition (the shrunk partition). This is very scary but is actually harmless as the data is not written to the disk until you write the changes to the disk.
        use n to create a new primary partition. Make sure its start cylinder is exactly the same as the old /dev/sda1 used to have. For the end cylinder agree with the default choice, which is to make the partition to span the whole disk.
        use a to toggle the bootable flag on the new /dev/sda1 (not required on Hades)
        use w to write the new partition table to disk. You'll get a message telling that the kernel couldn't re-read the partition table because the device is busy, but that's ok.

    Reboot with sudo reboot. When the system boots, you'll have a smaller filesystem living inside a larger partition.

    The next magic command is resize2fs. Run sudo resize2fs /dev/sda1 - this form will default to making the filesystem to take all available space on the partition.

    df -h to make sure that the partition resized correct
    
    echo success!
    
    
matt

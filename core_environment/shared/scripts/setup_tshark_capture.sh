#!/bin/bash

################################################################################
#
#  Set up tshark
#
################################################################################

# Immediately end on failure
set -e

#Add the user to group wireshark 
sudo adduser `whoami` wireshark

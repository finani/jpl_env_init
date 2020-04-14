#!/bin/bash 

export DEBIAN_FRONTEND=noninteractive

RELEASE=$(lsb_release -r -s)
case $RELEASE in
    16.04*)
        # Install Ubuntu desktop
        apt-get install -y --no-install-recommends \
        ubuntu-desktop  \
        unity-lens-applications \
        unity-lens-files
        ;;
    18.04*)
        # Install Ubuntu desktop
        apt-get install -y --no-install-recommends \
                ubuntu-desktop
        ;;
esac

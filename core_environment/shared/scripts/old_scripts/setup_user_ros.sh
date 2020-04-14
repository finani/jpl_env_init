#!/bin/bash

USERNAME=$(whoami)
case $USERNAME in
    root)
        echo "This script must not be run as root. It sets up a user account to use ROS and optionally the subt simulator if installed."
        exit 1
        ;;
esac

RELEASE=$(lsb_release -r -s)
case $RELEASE in
    16.04*)
        ROS_DISTRO=kinetic

        pip install --user -U pip
        pip install --user -U \
            numpy \
            empy \
            future
        ;;
    18.04*)
        ROS_DISTRO=melodic

        # Python dependencies
        pip3 install --user -U pip
        pip3 install --user -U \
             numpy \
             empy
        ;;
esac

if [[ -e /opt/ros/${ROS_DISTRO}/setup.bash ]] ; then 
    LINE0="source /opt/ros/${ROS_DISTRO}/setup.bash"
    if grep -q "$LINE0" ~/.bashrc ; then
        echo "It appears you already have '$LINE0' in your .bashrc"
    else
        echo "Appending '$LINE0' in your .bashrc"
        echo  $LINE0 >> ~/.bashrc
    fi
fi

if [[ -e /opt/ros/subt/setup.bash ]]; then
    # Setup bash script
    LINE1="source /opt/ros/subt/setup.bash"
    if grep -q "$LINE1" ~/.bashrc ; then
        echo "It appears you already have '$LINE1' in your .bashrc"
    else
        echo "Appending '$LINE1' in your .bashrc"
        echo  $LINE1 >> ~/.bashrc
    fi  
    echo  $LINE1 >> ~/.bashrc
fi

#Do not run this command as root. It will cause problems later:
bash -l -c "rosdep update"



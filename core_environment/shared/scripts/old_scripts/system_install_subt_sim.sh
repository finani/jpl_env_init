#!/bin/bash

USERNAME=$(whoami)
case $USERNAME in
    root)
        echo "This script must not be run as root. It will use sudo as necessary."
        exit 1
        ;;
esac

RELEASE=$(lsb_release -r -s)
case $RELEASE in
    18.04*)
        echo "Detected 18.04 proceeding."
        ;;
    *)
        echo "Ubuntu 18.04 required to build and run the subt simulator. Aborting."
        exit 1
        ;;
esac

# Python dependencies
pip3 install --user -U pip
pip3 install --user -U \
    numpy \
    empy

#Do not run this command as root. It will cause problems later:
rosdep update

# Compile and install SubT Virtual Testbed
if [[ ! -e /opt/ros/subt ]]; then
  WORKDIR=$HOME/osrf_subt
  mkdir -p $WORKDIR/src

  # Download software
  cd $WORKDIR
  hg clone https://bitbucket.org/osrf/subt src -r 9973152
  wget -q https://s3.amazonaws.com/osrf-distributions/subt_robot_examples/releases/subt_robot_examples_latest.tgz
  tar xvf subt_robot_examples_latest.tgz

  # Build
  source /opt/ros/melodic/setup.bash
  catkin_make install

  # Install
  echo "Please type the sudo password if necessary to install in /opt/ros/subt"
  sudo cp -r $WORKDIR/install /opt/ros/subt

  # Setup bash script
  echo "source /opt/ros/melodic/setup.bash" >> /home/$USERNAME/.bashrc
  echo "source /opt/ros/subt/setup.bash" >> /home/$USERNAME/.bashrc
fi

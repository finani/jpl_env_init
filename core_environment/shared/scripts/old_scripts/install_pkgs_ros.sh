#!/bin/bash

RELEASE=$(lsb_release -r -s)
case $RELEASE in
    16.04*)
        ROS_DISTRO=kinetic
        ;;
    18.04*)
        ROS_DISTRO=melodic
        ;;
esac

################ GET US TO THE RIGHT DIRECTORY ######################
# whether or not we have a command
have() {
    type "$1" &> /dev/null
}
if ! have git ; then
    DEBIAN_FRONTEND=noninteractive apt-get install -y git # Needed to find the find TOPLEVEL dir
fi

set -e
# The following code finds the real DIR of this source file without symbolic links 
# and then tries to see if it's in a git repository. If yes, then go to the toplevel of that.
# If not fall back to the core_environment installed by the vagrant scripts.
# Author: Jeffrey A Edlund Dec 26 2018
SOURCE="${BASH_SOURCE[0]}"
#echo "SOURCE is '$SOURCE'"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  TARGET="$(readlink "$SOURCE")"
  if [[ $SOURCE == /* ]]; then
    #echo "SOURCE '$SOURCE' is an absolute symlink to '$TARGET'"
    SOURCE="$TARGET"
  else
    DIR="$( dirname "$SOURCE" )"
    #echo "SOURCE '$SOURCE' is a relative symlink to '$TARGET' (relative to '$DIR')"
    SOURCE="$DIR/$TARGET" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  fi
done
#echo "SOURCE is '$SOURCE'"
RDIR="$( dirname "$SOURCE" )"
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
#if [ "$DIR" != "$RDIR" ]; then
#  echo "DIR '$RDIR' resolves to '$DIR'"
#fi
#echo "DIR is '$DIR'"
#echo "SOURCE is '$SOURCE'"

cd $DIR
 # Check if the current directory is in a Git repository.
if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then
    # check if the current directory is in .git before running git checks
    if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then
        TOPLEVEL=$(git rev-parse --show-toplevel)
    fi
fi
VM_TOPLEVEL=/home/vagrant/core_environment
if [ -z "$TOPLEVEL" ]; then # Couldn't find the git toplevel
    if [ -e "$VM_TOPLEVEL" ]; then
        TOPLEVEL="$VM_TOPLEVEL"
    else
        echo "Unable to find core_environment toplevel. Aborting."
        exit
    fi
fi
cd $TOPLEVEL
################ GET US TO THE RIGHT DIRECTORY -- DONE ######################




# Setup apt repos and update software list
if [[ ! -e /etc/apt/sources.list.d/ros-latest.list ]]; then
  echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" \
      > /etc/apt/sources.list.d/ros-latest.list
  apt-key adv \
      --keyserver hkp://ha.pool.sks-keyservers.net:80 \
      --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
fi
if [[ ! -e /etc/apt/sources.list.d/gazebo-stable.list ]]; then
  echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" \
      > /etc/apt/sources.list.d/gazebo-stable.list
  echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-prerelease $(lsb_release -cs) main" \
      > /etc/apt/sources.list.d/gazebo-prerelease.list
  #wget http://packages.osrfoundation.org/gazebo.key -O - > ./gazebo.key
  apt-key add ${TOPLEVEL}/shared/keys/gazebo.key
fi

#realsense drivers
apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE || apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE
add-apt-repository "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo $(lsb_release -sc) main" -u

# Setup apt repos and update software list
if [[ ! -e /etc/apt/sources.list.d/nodesource.list  ]]; then
    ./shared/scripts/helpers/nodeJS_10.sh
    apt install nodejs
fi

#MongoDB
if [[ ! -e /etc/apt/sources.list.d/mongodb.list ]]; then 
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
    echo "deb https://repo.mongodb.org/apt/ubuntu $(lsb_release -sc)/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb.list
    apt update
fi
apt install mongodb-org python-pymongo

# wget https://downloads.mongodb.com/compass/mongodb-compass_1.15.1_amd64.deb
# dpkg -i mongodb-compass_1.15.1_amd64.deb
# mongodb-compass needs libgconf-2-4 , but doesn't install it.  May need to debug this.

apt-get update

# Install dependency
apt-get install -y \
    python-catkin-tools \
    libbluetooth-dev \
    libcwiid-dev \
    libgoogle-glog-dev \
    libspnav-dev \
    libusb-dev \
    librealsense2-dev

# Install ROS 
apt-get install -y \
    ros-${ROS_DISTRO}-desktop-full \
    ros-${ROS_DISTRO}-joystick-drivers \
    ros-${ROS_DISTRO}-pointcloud-to-laserscan \
    ros-${ROS_DISTRO}-robot-localization \
    ros-${ROS_DISTRO}-spacenav-node \
    ros-${ROS_DISTRO}-tf2-sensor-msgs \
    ros-${ROS_DISTRO}-twist-mux \
    ros-${ROS_DISTRO}-velodyne-simulator \
    ros-${ROS_DISTRO}-move-base-msgs \
    ros-${ROS_DISTRO}-navigation \
    ros-${ROS_DISTRO}-multimaster-fkie \
    ros-${ROS_DISTRO}-multimaster-msgs-fkie \
    ros-${ROS_DISTRO}-costmap-2d \
    ros-${ROS_DISTRO}-move-base \
    ros-${ROS_DISTRO}-rosbridge-server \
    ros-${ROS_DISTRO}-mavros-msgs

case $RELEASE in
    16.04*)
        apt-get install -y \
                gazebo7 \
                libgazebo7-dev
        ;;
    18.04*)
        apt-get install -y \
                gazebo9 \
                libgazebo9-dev
        ;;
esac


if [[ ! -e /etc/ros/rosdep/sources.list.d/20-default.list ]]; then
    # Setup rosdep
    rosdep init
fi

# After this you can run system_install_subt_sim.sh as a user with sudo privileges to build and install the subt simulator

#For each user account using ros run setup_user_ros.sh to setup the .bashrc etc. (change to that user and then run the script).

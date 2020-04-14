#!/bin/bash

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


export DEBIAN_FRONTEND=noninteractive

apt-get update
#apt-get upgrade -y

PKGS=`sed 's/#.*//' <<PACKAGE_LIST | grep -v '^$' 
# Track changes in /etc using git
etckeeper

#Comms requests
iftop
fping
nmap
socat
netcat
# test pimd first
#pimd
iperf

# List of software from the vagrant
gnome-terminal
xterm
gdb
build-essential
lsb-release
vim
emacs
#sublime-text
git
mercurial
cmake
pkg-config

#ssh helpers
sshfs
rsync

# admin helpers
aptitude 
#unattended-upgrades


#user helpers
tree 
# remote terminal helpers
byobu

#scripting languages
python-mode python-ropemacs pylint


# For lndir: a tool that creates a shadow directory of symbolic links to another directory tree
xutils-dev

#Kernel headers
linux-headers-$(uname -r)

git git-gui git-svn
# svn
subversion 
# rapidsvn kdesvn

# mercurial
mercurial hgview mercurial-git mercurial-nested 
# tortoisehg

# multiple systems
# tailor
mr
python3-vcstool

#Diffing tools
diffuse meld

#Movies
#mplayer
vlc

#images
gimp xzgv imagemagick okular feh

#web
chromium-browser
firefox

#virtual machines
#virtualbox
#virtualbox-qt

# At Kyon's request
mesa-utils

#WIP: ORBSLAM dependencies
libxkbcommon-dev
libglew-dev

# simulation_px4
python-toml

# From hackathons
python-jinja2
python-numpy

#ORBSLAM
libxkbcommon-dev
libglew-dev

#For BLAM ubuntu 18
libmetis-dev

#velodyne Driver
libpcap-dev

PACKAGE_LIST`

apt-get install -y $PKGS
apt-get upgrade -y

RELEASE=$(lsb_release -r -s)
case $RELEASE in
    16.04*)
        # Use tmux 2.7
        TMUX_VERSION=2.7
        if [[ ! -e "$(command -v tmux)" ]] \
               || [[ "$(tmux -V | cut -d' ' -f2)" != "${TMUX_VERSION}" ]]; then
            apt-get remove -y tmux
            dpkg -i ./shared/pool/tmux-${TMUX_VERSION}-x86_64.deb
        fi
        apt-get install -y python \
                ipython \
                python-pip \
                python-virtualenv \
                # install tmuxp somehow
        # JAE: The commands below are in setup_user_ros.sh
        # pip install -U pip
        # pip install -U \
        #     numpy \
        #     empy \
        #     future
        ;;
    18.04*)
        apt-get install -y \
                tmux \
                tmuxp \
                ipython3 \
                python3 \
                python3-pip \
                python3-venv

        # JAE: The commands below are in setup_user_ros.sh
        # Python dependencies
        # pip3 install -U pip
        # pip3 install -U \
        #      numpy \
        #      empy
        ;;
esac




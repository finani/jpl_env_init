#!/bin/bash
################ GET US TO THE RIGHT DIRECTORY ######################
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

# https://bitbucket.org/osrf/subt/wiki/tutorials/SystemSetupDocker
#Remove any existing docker (because it's likely too old)

sudo apt-get remove docker docker-engine docker.io



sudo apt install curl apt-transport-https ca-certificates curl software-properties-common
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg > ./shared/keys/docker.key
sudo apt-key add ./shared/keys/docker.key

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) edge"

sudo apt-get update && sudo apt-get install docker-ce


#Check your Docker installation:

sudo docker run hello-world

#Install Nvidia Docker

#    Setup the Nvidia Docker repository.
#curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey > nvidia-github.key
sudo apt-key add ./shared/keys/nvidia-github.key
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
#distribution=ubuntu18.04
# curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list > ./shared/nvidia-docker-${distribution}.list
sudo cp ./shared/nvidia-docker-${distribution}.list /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update


#    Remove old versions of Nvidia Docker:

docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f

sudo apt-get purge nvidia-docker


#Install Nvidia Docker (version 2):

sudo apt-get install nvidia-docker2

#Restart the Docker daemon

sudo service docker restart

#Verify the installation:

docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi # This fails on the card that we have in autonomy.

# Troubleshooting:

# permission error

# If this is the first time you've used Docker on this machine, when you run the above command you may get an error similar to...

#     docker: Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post http://%2Fvar%2Frun%2Fdocker.sock/v1.37/containers/create: dial unix /var/run/docker.sock: connect: permission denied. See 'docker run --help'.

# You will need to add your user account the docker group,

#     sudo usermod -a -G docker $USER

# and then logout-log-back-in for the changes to take effect.

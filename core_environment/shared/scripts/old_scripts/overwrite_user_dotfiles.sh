#!/bin/bash

################ GET US TO THE RIGHT DIRECTORY ######################
# whether or not we have a command
have() {
    type "$1" &> /dev/null
}
if ! have git ; then
    DEBIAN_FRONTEND=noninteractive sudo apt-get install -y git # Needed to find the find TOPLEVEL dir
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

# Note that -b means that old files are backed up with a suffix of ~ 
rsync -a -b ${TOPLEVEL}/shared/dotfiles/ ~/ --exclude='README.md' --include='.*'


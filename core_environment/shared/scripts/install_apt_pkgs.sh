#!/bin/bash

################################################################################
#
#  Install APT packages from a file
#
#  Usage:
#    # install_apt_pkgs.sh <package>.list
#
################################################################################

export DEBIAN_FRONTEND=noninteractive

# Immediately end on failure
set -e

# Package list
package_list_path=$1

# Source utility functions
script_dir=$(dirname "$0")
. $script_dir/utilities.sh

# Check user
check_user_or_fail root

# Ubuntu release
release=$(lsb_release --short --code)

# ROS release
case $release in
  xenial)
    ROS_DISTRO=kinetic
    ;;
  bionic)
    ROS_DISTRO=melodic
    ;;
esac

################################################################################
# Set up repositories and keys
print_status "Setting up private APT repsitories"
$script_dir/setup_apt_repositories.sh

# Update package list
print_status "Updating package list (this may take a while)"
apt update -qq

################################################################################
# Install APT packages
apt_args="--assume-yes -qq"
export RTI_NC_LICENSE_ACCEPTED=yes

print_status "Installing packages from $package_list_path"
apt_install_from_file $package_list_path $release $apt_args

################################################################################
# Summary
print_status "Command successfully terminated: $0"
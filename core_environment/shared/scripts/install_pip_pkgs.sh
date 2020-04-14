#!/bin/bash

################################################################################
#
#  Install pip packages from a file
#
#  Usage:
#    # install_pip_pkgs.sh <package>.list
#
################################################################################

# Immediately end on failure
set -e

# Parse args
if [[ "$#" -ne 1 ]]; then
  echo "Usage: $0 <package>.list"
  exit 1
else
  package_list_path=$1
fi

# Source utility functions
script_dir=$(dirname "$0")
. $script_dir/utilities.sh

# Check user
check_normal_user_or_fail

################################################################################
# Install packages
print_status "Installing packages from $package_list_path"
pip2 install --user -r $package_list_path

################################################################################
# Summary
print_status "Command successfully terminated: $0"
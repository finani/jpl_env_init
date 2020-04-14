#!/bin/bash

################################################################################
#
#  Scan local apt packages and create a list
#
################################################################################

# Immediately end on failure
set -e

# Directories
toplevel_dir=$(cd "$(dirname "$0")" && git rev-parse --show-toplevel)
script_dir=$toplevel_dir/shared/scripts

# Source utility functions
. $script_dir/utilities.sh

# Check user
check_normal_user_or_fail

# Creat a list
for release in bionic xenial; do
  repo_dir=$toplevel_dir/shared/apt/pool/$release
  print_status "Creating a local package list from: $repo_dir"
  mkdir -p $repo_dir
  cd $repo_dir
  dpkg-scanpackages . /dev/null > ./Packages
done

################################################################################
# Summary
print_status "Command successfully terminated: $0"
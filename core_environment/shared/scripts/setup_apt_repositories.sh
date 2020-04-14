#!/bin/bash

################################################################################
#
#  Set up APT repositories and register GPG keys
#
################################################################################

# Immediately end on failure
set -e

# Directories
toplevel_dir=$(cd "$(dirname "$0")" && git rev-parse --show-toplevel)
key_dir=$toplevel_dir/shared/apt/keys
list_dir=$toplevel_dir/shared/apt/sources.list.d
script_dir=$toplevel_dir/shared/scripts

# Source utility functions
. $script_dir/utilities.sh

# Check user
check_user_or_fail root

# Add repository URL
print_status "Registering repository URLs"
cat $list_dir/*.list | xargs -I {} sh -c "apt-add-repository --no-update \"{}\""

cat $list_dir/local.list | xargs -I {} sh -c "apt-add-repository -r --no-update \"{}\""
cat $list_dir/local.list | xargs -I {} sh -c "echo \"{}\" >> /etc/apt/sources.list"


# Add gpg keys
print_status "Registering GPG keys"
ls $key_dir/*.key | xargs apt-key add

################################################################################
# Summary
print_status "Command successfully terminated: $0"

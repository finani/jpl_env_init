check_user_or_fail ()
{
  expected_user=$1
  user=$(whoami)
  if [[ "$expected_user" == "$user" ]]; then
    return 0
  else
    echo_err "You need to be '$expected_user' to run this script (current: $user)"
    exit 1
  fi
}


check_normal_user_or_fail ()
{
  user=$(whoami)
  if [[ "root" == "$user" ]]; then
    echo_err "You should not be 'root' to run this script"
    exit 1
  fi
}


apt_install_from_file ()
{
  filename=$1
  release_code=$2
  extra_args=${@:3}

  packages=`get_package_list_from_file $filename $release_code`

  if [[ -z "$packages" ]]; then
    echo "No package found in $filename"
    return 1
  else
    apt install $extra_args $packages
  fi
}


get_package_list_from_file ()
{
  filename=$1
  release_code=$2

  # Check if release is supported
  supported_releases=(xenial bionic)
  if list_contains release_code ${supported_releases[@]}; then
    echo_err "Release $release_code is not supported (Available: ${supported_releases[@]})"
    return 1
  fi

  # File not exist
  if [[ ! -e "$filename" ]]; then
    echo_err "File not exist: $filename"
    return 1
  fi

  # Common packages
  packages=$(sed "/xenial/d; /bionic/d" $filename | remove_comments | tr "\n" " ")

  # Release specific packages
  packages+=$(grep "$release_code" $filename | remove_comments | tr "\n" " ")

  # Expand env variables
  eval echo "$packages"
}


print_status ()
{
  echo ">>> $@"
}


echo_err ()
{
  >&2 echo "E>> $@"
}


remove_comments ()
{
  grep -vE "^\s*#" < /dev/stdin | sed -e "s/#.*$//"
}


list_contains ()
{
  value=$1
  array=$2
  if [[ " ${array[@]} " =~ " ${value} " ]]; then
    return 0
  else
    return 1
  fi
}


join_by ()
{
  local IFS="$1"
  shift
  echo "$*"
}

#!/bin/bash

# Need to install shunit2 to run these tests

. ../utilities.sh

testCheckUser()
{
  current_user=$(whoami)
  result=`check_user_or_fail $current_user`
  assertTrue $?
}


testCheckUserWithInvalidUser()
{
  result=`check_user_or_fail non_existent_user`
  assertFalse $?
}


testPackageListParser ()
{
  filename=$SHUNIT_TMPDIR/apt_package.list
  echo '
# This is a comment
  # This is a comment with extra spaces
package0
package1

package2  # inline comment
package3  # bionic only
' > $filename

  result=`get_package_list_from_file $filename bionic`
  expected="package0 package1 package2 package3"
  assertEquals "$expected" "$result"

  result=`get_package_list_from_file $filename xenial`
  expected="package0 package1 package2"
  assertEquals "$expected" "$result"
}

testPackageListParserWithNonExistentFile ()
{
  filename=non_existent_file
  result=`get_package_list_from_file $filename`
  assertFalse $?
}


testAptInstallWithEmptyFile ()
{
  filename=$SHUNIT_TMPDIR/empty_package.list
  echo "# empty package list" > $filename
  result=`apt_install_from_file $filename`
  assertFalse $?
}


testStatusPrint ()
{
  result=`print_status abc`
  assertEquals ">>> abc" "$result"
  result=`print_status abc def`
  assertEquals ">>> abc def" "$result"
}


testListContains ()
{
  array=(a b c)
  result=`list_contains a ${array[@]}`
  assertTrue $?
  result=`list_contains d ${array[@]}`
  assertFalse $?
}


testJoinBy ()
{
  array=(a b c)
  result=`join_by , ${array[@]}`
  assertEquals "a,b,c" $result
  result=`join_by : ${array[@]}`
  assertEquals "a:b:c" $result
}


. shunit2
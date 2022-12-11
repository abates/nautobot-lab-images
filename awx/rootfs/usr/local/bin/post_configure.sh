#!/bin/bash

function run_script() {
  file=$1
  if [ -d $file ] ; then
    for file in $file/* ; do
      run_script $file
    done
  elif [ -f $file ] ; then
    echo "Running configuration script $file"
    $file
  fi
}

function load_fixture() {
  fixture=$1
  if [ -d $fixture ] ; then
    for fixture in $fixture/* ; do
      load_fixture $fixture
    done
  elif [ -f $fixture ] ; then
      echo -n "Loading fixture $fixture: "
      awx-manage loaddata $fixture
  fi
}

for t in 1 10 30 30 30 30 ; do
  echo "Running post-up configuration"
  if awx ping 2>&1 > /dev/null ; then
    # Load any fixtures
    load_fixture /opt/awx/fixtures

    # Run configuration scripts
    run_script /opt/awx/conf.d
    exit 0
  fi
  echo "AWX is not up yet, waiting for $t seconds"
  sleep $t
done
>&2 echo "Failed to run post-up configuration. AWX does not appear to be ready (awx ping returned non-zero). Gave up after 5 tries"
exit 1

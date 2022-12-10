#!/bin/bash
set +x

function run_script() {
  file=$1
  if [ -d $file ] ; then
    for file in $dir/* ; do
      run_script $file
    done
  elif [ -f $file ] ; then
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

awx-manage migrate

if [ -n $TOWER_USERNAME ] && [ -n $TOWER_PASSWORD ]; then
  export DJANGO_SUPERUSER_PASSWORD=$TOWER_PASSWORD
  awx-manage createsuperuser --noinput --username=$TOWER_USERNAME --email=$TOWER_USERNAME@localhost 2> /dev/null
fi

awx-manage register_default_execution_environments

awx-manage provision_instance --hostname="awx-localhost" --node_type="hybrid"
awx-manage register_queue --queuename=controlplane --instance_percent=100
awx-manage register_queue --queuename=default --instance_percent=100

if [ $ANSIBLE_TOWER_SAMPLES == "true" ] ; then
  awx-manage create_preload_data
fi

# Load any fixtures
load_fixture /opt/awx/fixtures

# Run configuration scripts
run_script /opt/awx/conf.d

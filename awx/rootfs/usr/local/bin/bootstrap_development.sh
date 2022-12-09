#!/bin/bash
set +x

awx-manage migrate

export DJANGO_SUPERUSER_PASSWORD=awx
if output=$(awx-manage createsuperuser --noinput --username=awx --email=awx@localhost 2> /dev/null); then
    echo $output
fi

awx-manage register_default_execution_environments

awx-manage provision_instance --hostname="awx-localhost" --node_type="hybrid"
awx-manage register_queue --queuename=controlplane --instance_percent=100
awx-manage register_queue --queuename=default --instance_percent=100

if [ $ANSIBLE_TOWER_SAMPLES == "true" ] ; then
  awx-manage create_preload_data
fi

# Load any fixtures
AWX_FIXTURES=/opt/awx/fixtures
if [ -d $AWX_FIXTURES ] ; then
  for FIXTURE_DIR in `ls $AWX_FIXTURES` ; do
    for fixture in `ls $AWX_FIXTURES/$FIXTURE_DIR` ; do
      echo -n "Loading fixture $AWX_FIXTURES/$FIXTURE_DIR/$fixture: "
      awx-manage loaddata $AWX_FIXTURES/$FIXTURE_DIR/$fixtur
    done
  done
fi

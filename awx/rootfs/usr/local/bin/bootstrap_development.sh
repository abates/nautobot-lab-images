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

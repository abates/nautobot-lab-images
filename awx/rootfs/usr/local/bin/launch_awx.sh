#!/bin/bash
set +x

source /var/lib/awx/venv/awx/bin/activate

awx-manage migrate

if [ -n $TOWER_USERNAME ] && [ -n $TOWER_PASSWORD ]; then
  export DJANGO_SUPERUSER_PASSWORD=$TOWER_PASSWORD
  awx-manage createsuperuser --noinput --username=$TOWER_USERNAME --email=$TOWER_USERNAME@localhost 2> /dev/null
fi

awx-manage register_default_execution_environments

awx-manage provision_instance --hostname="awx-localhost" --node_type="hybrid"
awx-manage register_queue --queuename=controlplane --instance_percent=100
awx-manage register_queue --queuename=default --instance_percent=100

if [ "$ANSIBLE_TOWER_SAMPLES" = "true" ] ; then
  awx-manage create_preload_data
fi


# Start the services
exec supervisord --pidfile=/tmp/supervisor_pid -n

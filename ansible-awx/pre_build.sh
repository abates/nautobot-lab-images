#!/bin/sh

cd ansible-awx-build

ansible-playbook -v tools/ansible/build.yml \
  -e awx_image=$IMAGE_NAME \
  -e awx_version=$VERSION \
  -e ansible_python_interpreter=$(which python3) \
  -e push=no \
  -e awx_official=yes

cd ..

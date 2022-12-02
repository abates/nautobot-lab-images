#!/bin/bash

cat << EOF > /etc/passwd
root:x:0:0:root:/root:/bin/bash
awx:x:501:501:,,,:/var/lib/awx:/bin/bash
nginx:x:`id -u nginx`:`id -g nginx`:Nginx web server:/var/lib/nginx:/sbin/nologin
EOF

cat <<EOF >> /etc/group
awx:x:`id -u`:awx
EOF

cat <<EOF > /etc/subuid
awx:100000:50001
EOF

cat <<EOF > /etc/subgid
awx:100000:50001
EOF

# Required to get rootless podman working after
# writing out the sub*id files above
podman system migrate

exec $@

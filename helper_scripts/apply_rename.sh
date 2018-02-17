#!/bin/bash

# echo "swport rename -t port-mac -su -m $1=$2" | sudo tee -a /etc/rc.d/rc.netinit > /dev/null
cat << EOF >> /etc/rc.d/rc.netinit
swport rename -t port-mac -su -m $1=$2
EOF

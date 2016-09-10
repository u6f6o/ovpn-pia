#!/bin/bash 

# create tun device
[ -d /dev/net ] || mkdir -p /dev/net
[ -c /dev/net/tun ] || mknod /dev/net/tun c 10 200

# add tun to modules
echo "tun" >> /etc/modules 
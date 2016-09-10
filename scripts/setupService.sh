#!/bin/bash 

mkdir /etc/services.d/openvpn

cat << EOF > /etc/services.d/openvpn/run
#!/usr/bin/with-contenv sh
openvpn --config /etc/openvpn/Sweden.ovpn --auth-nocache
EOF

cat << EOF > /etc/services.d/openvpn/finish
#!/bin/sh
s6-svscanctl -t /var/run/s6/services
EOF
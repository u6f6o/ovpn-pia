#!/bin/bash 

# create tun device
#[ -d /dev/net ] || mkdir -p /dev/net
#[ -c /dev/net/tun ] || mknod /dev/net/tun c 10 200
#chown openvpn:openvpn /dev/net/tun 
#chmod 666 /dev/net/tun

# add tun to modules
echo "tun" >> /etc/modules 

# create unpriv-ip 
mkdir -p /usr/local/sbin/
echo "#!/bin/sh" >> /usr/local/sbin/unpriv-ip
echo "sudo /sbin/ip \$*" >> /usr/local/sbin/unpriv-ip

# allow sudo call 
echo "openvpn ALL=(ALL) NOPASSWD: /sbin/ip" >> /etc/sudoers
echo "Defaults:openvpn !requiretty" >> /etc/sudoers

chmod 755 /usr/local/sbin/unpriv-ip
chown openvpn:openvpn /etc/openvpn -R
 
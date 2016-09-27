#!/bin/bash 

# add tun to modules
echo "tun" >> /etc/modules 

# create unpriv-ip 
mkdir -p /usr/local/sbin/

cat <<EOF >> /usr/local/sbin/unpriv-ip
#!/bin/sh
sudo /sbin/ip \$*
EOF

chown openvpn:openvpn /usr/local/sbin/unpriv-ip
chmod ugo-rwx /usr/local/sbin/unpriv-ip
chmod ug+rx /usr/local/sbin/unpriv-ip

# allow openvpn to execute /sbin/ip
cat <<EOF >> /etc/sudoers
openvpn ALL=(ALL) NOPASSWD: /sbin/ip
Defaults:openvpn !requiretty
EOF

chown openvpn:openvpn /etc/openvpn -R 
sed -i 's/^\(netdev:.\+\)$/\1openvpn/' /etc/group
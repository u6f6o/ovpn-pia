#!/bin/bash 

# download and unzip PIA configuration
unzip -q openvpn.zip

# change credentials, provide absolute paths


# sed -i 's/\(auth-user-pass\)/\1 /etc/openvpn/pass.txt/g' *.ovpn
sed '/auth-user-pass/d' *.ovpn
sed -i 's/\(crl[a-zA-Z0-9.]*pem\)/\/etc\/openvpn\/\1/g' *.ovpn
sed -i 's/\(ca[a-zA-Z0-9.]*crt\)/\/etc\/openvpn\/\1/g' *.ovpn
# sed -i '$ a daemon' *.ovpn

# copy openvpn config files 
for f in *.ovpn; do 
	cp -v "$f" "/etc/openvpn/${f// /_}" || exit 1
done

# copy certificate files
cp -v *.pem /etc/openvpn || exit 1
cp -v *.crt /etc/openvpn || exit 1

# basic checks for openvpn config and cert files
if [ `ls /etc/openvpn/*.ovpn | wc -l` -lt 20 ]; then 
	echo "Openvpn config files missing after copy."
	exit 1 
fi

if [ `ls /etc/openvpn/*.pem | wc -l` -ne 1 ]; then 
	echo "Openvpn pem file missing after copy."
	exit 1
fi

if [ `ls /etc/openvpn/*.crt | wc -l` -ne 1 ]; then 
	echo "Openvpn crt file missing after copy."
	exit 1
fi
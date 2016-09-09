#!/bin/bash 

# download and unzip PIA configuration
curl -OLk https://www.privateinternetaccess.com/openvpn/openvpn.zip 
unzip openvpn.zip

# change credentials, provide absolute paths
sed -i 's/\(auth-user-pass\)/\1 USER PW/g' *.ovpn
sed -i 's/\(crl[a-zA-Z0-9.]*pem\)/\/etc\/openvpn\/\1/g' *.ovpn
sed -i 's/\(ca[a-zA-Z0-9.]*crt\)/\/etc\/openvpn\/\1/g' *.ovpn

# remove spaces in files and copy them to /etc/openvpn
for f in *.ovpn; do 
	cp "$f" "/etc/openvpn/${f// /_}"; 
done

# copy certs over
cp *.pem /etc/openvpn
cp *.crt /etc/openvpn


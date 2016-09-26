# ovpn-pia
Alpine docker image with openvpn for pia (https://www.privateinternetaccess.com) and iptable rules to enforce VPN usage. 

## Usage

    docker run -i -t --privileged --dns=209.222.18.222 --dns=209.222.18.218 \
	    -e PIA_USER='YOUR_PIA_USER' \
 	    -e PIA_PASSWORD='YOUR_PIA_PASSWORD' \
	    -e PIA_REGION='Switzerland' \	 
	    u6f6o/openvpn-pia:latest


#!/usr/bin/with-contenv bash

# IPTABLE rules according to  
# https://airvpn.org/topic/9139-prevent-leaks-with-linux-iptables/
# with some minor modifications

# parse vpn host from config file
vpnHost=$(grep 'remote ' /etc/openvpn/service.conf | cut -d ' ' -f2)

if [ -z "$vpnHost" ]; then
    echo "Unable to resolve VPN host"
    exit 1
fi

# resolve VPN host IPs using nslookup
vpnHostIPs=$(nslookup ${vpnHost} 2>&1 | grep -E 'Address \d' | grep -oE '\d+(\.\d+){3}')

if [ -z "$vpnHostIPs" ]; then
    echo "Unable to resolve IPs for VPN host"
    exit 1
fi

# extract DNS ips from resolv.conf
dnsIPs=$(grep nameserver /etc/resolv.conf | cut -d ' ' -f2)

if [ -z "$dnsIPs" ]; then
    echo "Unable to resolve IPs for DNS servers"
    exit 1
fi

# flush existing iptables rules
iptables -F

# loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# dns 
for ip in $dnsIPs 
do
	iptables -A OUTPUT -p udp -d $ip --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
	iptables -A INPUT  -p udp -s $ip --sport 53 -m state --state ESTABLISHED     -j ACCEPT
	iptables -A OUTPUT -p tcp -d $ip --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
	iptables -A INPUT  -p tcp -s $ip --sport 53 -m state --state ESTABLISHED     -j ACCEPT
done

# local network
iptables -A INPUT -s 192.168.0.0/16 -d 192.168.0.0/16 -j ACCEPT
iptables -A OUTPUT -s 192.168.0.0/16 -d 192.168.0.0/16 -j ACCEPT


iptables -A OUTPUT -j ULOG 
iptables -A INPUT -j ULOG



#iptables -A INPUT -p tcp -s 172.17.0.1 -d 172.17.0.2 --dport 9091 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -p tcp -s 172.17.0.2 --sport 9091 -d 172.17.0.1 -m state --state ESTABLISHED -j ACCEPT
#iptables -A INPUT -p udp -s 172.17.0.1 -d 172.17.0.2 --dport 9091 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -p udp -s 172.17.0.2 --sport 9091 -d 172.17.0.1 -m state --state ESTABLISHED -j ACCEPT



# eth+ <-> tun+ communication
iptables -A FORWARD -i eth+ -o tun+ -j ACCEPT
iptables -A FORWARD -i tun+ -o eth+ -j ACCEPT 

 # in the POSTROUTING chain of the NAT table, 
 # map the tun+ interface outgoing packet IP address, 
 # cease examining rules and let the header be modified, 
 # so that we don't have to worry about ports or any other issue 
 # - please check this rule with care if you have already a NAT table in your chain
iptables -t nat -A POSTROUTING -o tun+ -j MASQUERADE 

iptables -A INPUT -m state --state RELATED,ESTABLISHED -p udp --dport 61111 -j ACCEPT
iptables -A OUTPUT -p udp --sport 61111 -j ACCEPT

# allow outgoing connections on eth+ towards the vpn servers 
for ip in $vpnHostIPs 
do 
	iptables -A OUTPUT -o eth+ -d $ip -j ACCEPT	
done

iptables -A INPUT -j DROP

# disallow everything else on eth+
iptables -A OUTPUT -j LOG --log-prefix "OUTPUT:DROP:" --log-level 6
#iptables -A OUTPUT -o eth+ -j DROP

#iptables -F



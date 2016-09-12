# docker-openvpn-pia
Alpine docker image with openvpn for pia (https://www.privateinternetaccess.com) and iptable rules to enforce VPN usage. 

## Usage

    docker run -i -t --privileged --dns=209.222.18.222 --dns=209.222.18.218 \
	    -e PIA_USER='YOUR_PIA_USER' \
 	    -e PIA_PASSWORD='YOUR_PIA_PASSWORD' \
	    -e PIA_REGION='Switzerland' \	 
	    u6f6o/openvpn-pia:latest

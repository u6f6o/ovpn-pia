# docker-openvpn-pia
Alpine docker image with openvpn for pia (https://www.privateinternetaccess.com)

## Usage

    docker run -i -t --privileged --dns=8.8.8.8 \
	    -e PIA_USER='YOUR_PIA_USER' \
 	    -e PIA_PASSWORD='YOUR_PIA_PASSWORD' \
	    -e PIA_REGION='Switzerland' \
	    u6f6o/openvpn-pia:v1.0

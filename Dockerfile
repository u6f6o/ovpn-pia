FROM alpine:latest

# s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.18.1.5/s6-overlay-amd64.tar.gz /tmp/install/s6-overlay/

# pia openvpn configuration
ADD https://www.privateinternetaccess.com/openvpn/openvpn.zip /tmp/install/openvpn/

# scripts for openvpn installation
ADD scripts/ /tmp/install/openvpn/

# install s6-overlay
RUN tar -xzf /tmp/install/s6-overlay/s6-overlay-amd64.tar.gz -C /

# install necessary packages
RUN apk update \
	&& apk upgrade \
	&& apk add --no-cache bash unzip openvpn \
	&& rm -rf /var/cache/apk/* 	

# change location to setup scripts
WORKDIR /tmp/install/openvpn/
	
# configure openvpn
RUN /bin/bash setupPIA.sh \
	&& /bin/bash setupTUN.sh

CMD ["openvpn", "--config", "/etc/openvpn/Sweden.ovpn"]
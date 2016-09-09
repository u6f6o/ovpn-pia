FROM alpine:3.2

ADD scripts/ /var/tmp/openvpn_setup

# install necessary packages
RUN apk update \
	&& apk upgrade \
	&& apk add bash curl unzip openvpn \
	&& rm -rf /var/cache/apk/* \
	&& rc-update add openvpn default \
	&& echo "tun" >> /etc/modules \
	&& cd /var/tmp/openvpn_setup \
	&& /bin/bash setup.sh \ 
	&& rm -rf /var/tmp/openvpn_setup


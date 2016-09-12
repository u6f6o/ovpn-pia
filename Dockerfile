FROM alpine:latest

MAINTAINER Ulf Gitschthaler

ENV s6version "v1.18.1.5"

# install necessary packages
RUN apk update \
	&& apk upgrade \
	&& apk add --no-cache bash unzip openvpn \
	&& rm -rf /var/cache/apk/* 

# prepare install directory
ADD https://github.com/just-containers/s6-overlay/releases/download/${s6version}/s6-overlay-amd64.tar.gz /tmp/install/s6-overlay/
ADD https://www.privateinternetaccess.com/openvpn/openvpn.zip /tmp/install/openvpn/
ADD scripts/setup/ /tmp/install/openvpn/

# install s6-overlay
RUN tar -xzf /tmp/install/s6-overlay/s6-overlay-amd64.tar.gz -C /

# copy service init and config scripts
RUN mkdir /etc/services.d/openvpn
ADD scripts/service/openvpn/ /etc/services.d/openvpn/
ADD scripts/service/01-contenv-pia /etc/cont-init.d/

# configure openvpn
RUN cd /tmp/install/openvpn \
	&& /bin/bash setupPIA.sh \
	&& /bin/bash setupTUN.sh 

# cleanup 
RUN rm -rf /tmp/install 

ENTRYPOINT ["/init"]
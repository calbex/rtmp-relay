FROM smebberson/alpine-base:3.0.0
MAINTAINER Caleb

# Update and install tools
RUN apk update && \
    apk upgrade && \
    apk add ca-certificates && \
    apk add wget && \
    apk add openssl-dev && \
    apk add --update alpine-sdk && \
    rm -rf /var/cache/apk/*

ARG NGINXVER=1.10.1
ARG RTMPVER=1.1.8

# Download nginx and rtmp server source
WORKDIR /tmp

# Unpack and remove
# Build and install nginx
RUN wget http://nginx.org/download/nginx-$NGINXVER.tar.gz && \
    tar -zxvf nginx-$NGINXVER.tar.gz && \
    rm nginx-$NGINXVER.tar.gz && \
    wget https://github.com/arut/nginx-rtmp-module/archive/v$RTMPVER.tar.gz && \
    tar -xvzf v$RTMPVER.tar.gz && \
    rm v$RTMPVER.tar.gz && \
    cd nginx-$NGINXVER && \
    ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-$RTMPVER --without-http_rewrite_module && \
    make && \
    make install && \
    cd /tmp && \
    rm -Rf nginx-$NGINXVER/ nginx-rtmp-module-$RTMPVER/

# Add www-data user
RUN adduser -DH www-data

WORKDIR /
RUN mkdir config
COPY ./nginx.conf /usr/local/nginx/conf/nginx.conf

VOLUME ["/config"]

EXPOSE 1935

COPY ./startup.sh /home/startup.sh
RUN chmod 700 /home/startup.sh
ENTRYPOINT ["/home/startup.sh"]

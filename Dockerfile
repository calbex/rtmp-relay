FROM smebberson/alpine-base:3.0.0
MAINTAINER Caleb

# Update and install tools
RUN apk update && \
    apk upgrade && \
    apk add ca-certificates && \
    apk add wget && \
    apk add openssl-dev && \
    apk add --update alpine-sdk

ARG NGINXVER=1.10.1
ARG RTMPVER=1.1.8

# Download nginx and rtmp server source
WORKDIR /tmp
RUN wget http://nginx.org/download/nginx-$NGINXVER.tar.gz
RUN wget https://github.com/arut/nginx-rtmp-module/archive/v$RTMPVER.tar.gz

# Unpack and remove
RUN tar -zxvf nginx-$NGINXVER.tar.gz
RUN tar -xvzf v$RTMPVER.tar.gz
RUN rm nginx-$NGINXVER.tar.gz
RUN rm v$RTMPVER.tar.gz

# Install nginx
WORKDIR nginx-$NGINXVER
RUN ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-$RTMPVER --without-http_rewrite_module
RUN make
RUN make install

# Clean up files
WORKDIR /tmp
RUN rm -Rf nginx-$NGINXVER/ nginx-rtmp-module-$RTMPVER/

WORKDIR /
RUN mkdir config
COPY ./nginx.conf /usr/local/nginx/conf/nginx.conf

VOLUME ["/config"]

EXPOSE 80

COPY ./startup.sh /home/startup.sh
RUN chmod 700 /home/startup.sh
ENTRYPOINT ["/home/startup.sh"]

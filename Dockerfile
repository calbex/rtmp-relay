FROM smebberson/alpine-base:3.0.0
MAINTAINER Caleb

RUN apk update && \
    apk upgrade && \
    apk add ca-certificates && \
    apk add wget && \
    apk add openssl-dev && \
    apk add --update alpine-sdk

WORKDIR /tmp

RUN wget http://nginx.org/download/nginx-1.9.9.tar.gz
RUN wget https://github.com/arut/nginx-rtmp-module/archive/v1.1.8.tar.gz

RUN tar -zxvf nginx-1.9.9.tar.gz
RUN tar -xvzf v1.1.8.tar.gz

RUN rm nginx-1.9.9.tar.gz
RUN rm v1.1.8.tar.gz

WORKDIR nginx-1.9.9

RUN ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-1.1.8 --without-http_rewrite_module
RUN make
RUN make install

# Clean up files
WORKDIR /tmp
RUN rm -Rf nginx-1.9.9/ nginx-rtmp-module-1.1.8/

WORKDIR /
RUN mkdir config
COPY nginx.conf /usr/local/nginx/conf/nginx.conf

VOLUME ["/config"]

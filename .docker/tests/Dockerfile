FROM alpine:edge

RUN echo '@testing http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
  && echo '@community http://nl.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories \
  && echo '@edge http://nl.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories \
  && apk update && apk upgrade --no-cache --available && apk add --upgrade apk-tools@edge

RUN apk add --no-cache libmemcached-dev php7-pecl-protobuf php7-pecl-xdebug php7-pecl-memcached php7-pecl-imagick \
                       libmcrypt-dev php7-zlib php7 php7-dev gcc musl-dev g++ make php7-pecl-vips php7-pecl-redis php7-pecl-apcu php7-pecl-mcrypt \
                       php7-pecl-amqp php7-pecl-zmq php7-pecl-msgpack 

WORKDIR /opt

COPY test_memcached.php /opt/test_memcached.php
COPY test-redis.php /opt/test-redis.php
COPY check-memcache.php /opt/check-memcache.php
COPY docker-entrypoint.sh /opt/docker-entrypoint.sh
COPY tests.php /opt/tests.php

CMD ["/opt/docker-entrypoint.sh"]

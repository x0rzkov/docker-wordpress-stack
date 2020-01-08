#!/bin/sh

set -x
# set -e

cat /etc/hosts

ping redis -c 5
ping varnish -c 5
ping memcached -c 5

echo ""
php -v

echo ""
pwd

echo ""
ls -l

echo ""
php -q /opt/test_memcached.php ${MEMCACHED_HOST} ${MEMCACHED_PORT}

echo ""
php -q /opt/test-redis.php ${REDIS_HOST} ${REDIS_PORT}
# php -q /opt/check-memcache.php

echo ""
php -q tests.php

/bin/true

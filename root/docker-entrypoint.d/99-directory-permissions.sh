#!/bin/sh

set -eu

mkdir -p \
  /var/log/nginx \
  /var/cache/nginx \
  /run/nginx

chown www-data:www-data \
  /var/log/nginx \
  /var/log/nginx/access.log \
  /var/cache/nginx \
  /run/nginx

chmod 02755 \
  /var/log/nginx \
  /var/log/nginx/access.log \
  /var/cache/nginx \
  /run/nginx

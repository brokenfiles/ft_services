FROM wordpress:php7.4-fpm-alpine

RUN apk update && \
	apk add nginx mysql-client

COPY entrypoint /tmp/init.sh
COPY wordpress_dump-target.sql /wordpress-dump.sql

RUN sh /tmp/init.sh

ENTRYPOINT lighttpd -D -f /etc/lighttpd/lighttpd.conf
FROM wordpress:php7.4-fpm-alpine

RUN apk update && \
	apk add nginx mysql-client

COPY wordpress.sql /wordpress-dump.sql
COPY entrypoint /entrypoint

ENTRYPOINT sh /entrypoint

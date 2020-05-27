FROM alpine:latest

RUN apk update && \
	apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session && \
	mkdir /www

COPY startup.sh /tmp/startup.sh
COPY wordpress.tar.gz /www/wordpress.tar.gz
COPY wp-config.php /tmp/wp-config.php

RUN chmod 777 /tmp/startup.sh

ENTRYPOINT sh /tmp/startup.sh

EXPOSE 5050
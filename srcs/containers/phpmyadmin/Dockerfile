FROM alpine:latest

RUN apk update && \
	apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session

RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz && \
	tar -xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz && \
	mv phpMyAdmin-4.9.0.1-all-languages /www && \
	rm -rf /var/cache/apk/*

COPY startup.sh /tmp/startup.sh
COPY config.inc.php /www/config.inc.php

RUN chmod 777 /tmp/startup.sh
RUN chmod 650 /www/config.inc.php

ENTRYPOINT sh /tmp/startup.sh

EXPOSE 5000

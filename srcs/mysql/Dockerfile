FROM alpine

RUN apk add --update mysql mysql-client && \
	rm -f /var/cache/apk/*

COPY my.cnf /etc/mysql/my.cnf
COPY entrypoint /entrypoint
COPY wordpress.tar.gz /var/www/html/wordpress.tar.gz

RUN mkdir /app

EXPOSE 3306
CMD sh /entrypoint

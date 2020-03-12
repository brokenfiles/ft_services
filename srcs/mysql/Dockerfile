FROM alpine

RUN apk add --update mysql mysql-client && \
	rm -f /var/cache/apk/*

COPY my.cnf /etc/mysql/my.cnf
COPY entrypoint-target /tmp/entrypoint-target

RUN mkdir /app

EXPOSE 3306
CMD sh /tmp/entrypoint-target

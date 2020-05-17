FROM alpine:latest

RUN apk update && \
	apk add mariadb mariadb-client && \
	rm -rf /var/cache/apk/*

#copy files to the container
COPY startup.sh /tmp/startup.sh
COPY import_wordpress.sh /tmp/import_wordpress.sh
#configuration
COPY wordpress.sql /tmp/wordpress.sql
COPY mnk_ip /tmp/mnk_ip

#adding permissions to scripts
RUN chmod 777 /tmp/startup.sh
RUN chmod 777 /tmp/import_wordpress.sh

ENTRYPOINT sh /tmp/startup.sh

EXPOSE 3306

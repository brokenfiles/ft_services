FROM alpine:latest

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
	apk update && \
	apk add openssl && \
	apk add pure-ftpd && \
	rm -rf /var/cache/apk/*

COPY startup.sh /tmp/startup.sh
COPY mnk_ip /tmp/mnk_ip

ENTRYPOINT sh /tmp/startup.sh

EXPOSE 21 21000
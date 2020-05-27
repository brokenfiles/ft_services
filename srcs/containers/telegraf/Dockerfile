FROM alpine:latest

ENV TELEGRAF_VERSION 1.13.3

RUN apk update && \
	wget https://dl.influxdata.com/telegraf/releases/telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz && \
	tar -C . -xzf telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz && \
	chmod +x telegraf/* && \
	cp telegraf/telegraf /usr/bin/ && \
	rm -rf *.tar.gz* telegraf/

COPY startup.sh /tmp/startup.sh
COPY telegraf.conf /etc/telegraf/telegraf.conf

RUN chmod 777 /tmp/startup.sh

ENTRYPOINT sh /tmp/startup.sh

EXPOSE 4999
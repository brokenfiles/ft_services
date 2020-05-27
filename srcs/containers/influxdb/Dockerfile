FROM alpine:latest

RUN apk update && \
	apk add influxdb

COPY startup.sh /tmp/startup.sh

RUN chmod 777 /tmp/startup.sh

ENTRYPOINT sh /tmp/startup.sh

EXPOSE 8086
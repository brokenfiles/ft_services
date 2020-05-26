FROM alpine:latest

RUN apk update && \
	apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main libc6-compat && \
	wget https://dl.grafana.com/oss/release/grafana-6.7.3.linux-amd64.tar.gz && \
	tar -zxvf grafana-6.7.3.linux-amd64.tar.gz

COPY defaults.ini ./grafana-6.7.3/conf/defaults.ini
COPY grafana.db ./grafana-6.7.3/data/grafana.db
COPY startup.sh /tmp/startup.sh

RUN chmod 777 /tmp/startup.sh

ENTRYPOINT sh /tmp/startup.sh

EXPOSE 3000


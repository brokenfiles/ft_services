FROM nginx:alpine

RUN apk add --update openssh

COPY entrypoint-target /tmp/entrypoint-target

ENTRYPOINT sh /tmp/entrypoint-target

EXPOSE 443 80 22

FROM nginx:alpine

RUN apk add --update openssh

COPY entrypoint /entrypoint
COPY nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT sh /entrypoint

EXPOSE 443 80 22

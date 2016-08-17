FROM alpine:3.4
MAINTAINER Ryuichi Komeda <komeda@hivelocity.co.jp>

RUN apk add --update \
  bash \
  supervisor \
  nginx \
  && mkdir /run/nginx/ \
  && rm -rf /var/cache/apk/*

ADD files /

RUN chmod +x /entrypoint.sh

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]

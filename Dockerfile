FROM alpine:3.4
MAINTAINER Ryuichi Komeda <komeda@hivelocity.co.jp>

RUN apk add --update \
  bash \
  supervisor \
  nginx \
  && mkdir /var/run/nginx/ \
  && mkdir /var/run/supervisor/ \
  && rm -rf /etc/supervisord.conf \
  && rm -rf /var/cache/apk/*

ADD files /

RUN chmod +x /entrypoint.sh

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]

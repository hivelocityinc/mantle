FROM alpine:3.4
MAINTAINER Ryuichi Komeda <komeda@hivelocity.co.jp>

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
  # Installs Supervisor
  apk add --update \
    supervisor && \
  mkdir /var/run/supervisor/ && \
  rm -rf /etc/supervisord.conf && \
  # Installs Nginx
  apk add --update \
    nginx && \
  mkdir /var/run/nginx/ &&
  mkdir /var/www/html/ && \
  # Installs PHP
  apk add --update \
    php5 \
    php5-common \
    php5-fpm \
    php5-mysql \
    php5-pdo \
    php5-gd \
    php5-xml \
    php5-mcrypt \
    php5-imap \
    php5-opcache \
    php5-imagick \
    php5-memcache \
    php5-redis && \
  # Clean up cache
  rm -rf /var/cache/apk/*

COPY files /

RUN chmod +x /entrypoint.sh

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]

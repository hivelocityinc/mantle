FROM alpine:3.4
MAINTAINER Ryuichi Komeda <komeda@hivelocity.co.jp>

RUN apk add --update \
  bash && \

  # Installs Supervisor
  apk add --update \
    supervisor && \
  mkdir /var/run/supervisor/ && \
  rm -rf /etc/supervisord.conf && \

  # Installs Nginx
  apk add --update \
    nginx && \
  mkdir /var/run/nginx/ && \

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
    php5-opcache && \

  # Clean up cache
  rm -rf /var/cache/apk/*

ADD files /

RUN chmod +x /entrypoint.sh

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]

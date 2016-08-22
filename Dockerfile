FROM alpine:3.4
MAINTAINER Ryuichi Komeda <komeda@hivelocity.co.jp>

ENV ENTRYKIT_VERSION=0.4.0 \
    WORKER_PROCESSES=1 \
    SERVER_NAME='localhost' \
    DOCUMENT_ROOT='/usr/share/nginx/html' \
    MYSQL_ROOT_PASSWORD='root'

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
  # Installs EntryKit
  apk add --update openssl && \
  wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz && \
  tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz && \
  rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz && \
  mv entrykit /bin/entrykit && \
  chmod +x /bin/entrykit && \
  entrykit --symlink && \
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
    php5-json \
    php5-mcrypt \
    php5-imap \
    php5-opcache \
    php5-openssl \
    php5-imagick \
    php5-memcache \
    php5-redis && \
  apk add --update \
    mariadb mariadb-client && \
  rm -rf /var/lib/mysql && \
  mkdir -p /var/lib/mysql /var/run/mysqld /run/mysqld && \
  chown -R mysql:mysql /var/lib/mysql /var/run/mysqld /run/mysqld && \
  chmod -R 777 /var/run/mysqld /run/mysqld && \
  # Clean up cache
  rm -rf /var/cache/apk/*

COPY files /

RUN mysql_install_db --user=mysql --datadir="/var/lib/mysql" --rpm && \
  /usr/bin/mysqld --user=root --bootstrap --verbose=0 < /mysql_setup.sql

RUN chmod +x /entrypoint.sh

EXPOSE 80 443

ENTRYPOINT [ \
"render", \
  "/etc/nginx/nginx.conf", \
  "/etc/nginx/conf.d/default.conf", \
  "/etc/php5/php.ini", \
  "/etc/php5/php-fpm.conf", \
  "/etc/mysql/my.cnf", "--", \
"/entrypoint.sh" \
]

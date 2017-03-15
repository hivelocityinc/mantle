FROM alpine:3.5

MAINTAINER Ryuichi Komeda <komeda@hivelocity.co.jp>

ENV ENTRYKIT_VERSION=0.4.0 \
    NGINX_WORKER_PROCESSES=1 \
    NGINX_SERVER_NAME='localhost' \
    NGINX_DOCUMENT_ROOT='/usr/share/nginx/html' \
    MYSQL_ROOT_PASSWORD='root' \
    MYSQL_DATABASE='mantle' \
    MYSQL_USER='mantle' \
    MYSQL_PASSWORD='mantle' \
    MEMCACHED_MEMUSAGE=64 \
    MEMCACHED_MAXCONN=1024

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
  # Installs EntryKit
  apk add --update openssl curl bash && \
  wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz && \
  tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz && \
  rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz && \
  mv entrykit /bin/entrykit && \
  chmod +x /bin/entrykit && \
  entrykit --symlink && \
  # Installs Supervisor
  apk add --update \
    supervisor && \
  mkdir -p /var/run/supervisor/ /var/log/supervisor/ && \
  rm -rf /etc/supervisord.conf && \
  # Installs Nginx
  apk add --update \
    nginx && \
  mkdir -p /var/run/nginx/ /etc/nginx/ssl/ && \
  openssl genrsa -out /etc/nginx/ssl/server.key 2048 2>&1 && \
  openssl req -new -batch \
    -key /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.csr && \
  openssl x509 -req -days 365 \
    -in /etc/nginx/ssl/server.csr \
    -signkey /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt 2>&1 && \
  # Installs PHP
  apk add --update \
    php7 \
    php7-common \
    php7-ctype \
    php7-fpm \
    php7-mysqli \
    php7-phar \
    php7-pdo \
    php7-pdo_mysql \
    php7-dom \
    php7-gd \
    php7-xml \
    php7-json \
    php7-mcrypt \
    php7-mbstring \
    php7-imap \
    php7-zlib \
    php7-opcache \
    php7-openssl \
    php7-memcached \
    php7-redis && \
  mkdir -p /var/log/php-fpm/ && \
  ln -s /usr/bin/php7 /usr/bin/php && \
  curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar /usr/bin/composer && \
  wget https://phar.phpunit.de/phpunit.phar && \
  chmod +x phpunit.phar && \
  mv phpunit.phar /usr/bin/phpunit && \
  # Installs MariaDB
  apk add --update \
    mariadb mariadb-client && \
  rm -rf /var/lib/mysql && \
  mkdir -p /var/lib/mysql /var/run/mysqld /var/log/mysql && \
  chown -R mysql:mysql /var/lib/mysql /var/run/mysqld /var/log/mysql && \
  chmod 777 /var/run/mysqld && \
  # Installs Memcached
  apk add --update \
    memcached && \
  mkdir -p /var/run/memcached && \
  apk add --update \
    redis && \
  mkdir -p /etc/redis && \
  # Clean up cache
  rm -rf /var/cache/apk/*

VOLUME /var/lib/mysql

COPY files /

RUN chmod +x /entrypoint.sh

EXPOSE 80 443 3306

ENTRYPOINT [ \
  "render", \
    "/etc/nginx/nginx.conf", \
    "/etc/nginx/conf.d/default.conf", "--", \
  "render", \
    "/etc/nginx/conf.d/default.ssl.conf", "--", \
  "render", \
    "/etc/php7/php.ini", \
    "/etc/php7/php-fpm.conf", \
    "/etc/php7/php-fpm.d/www.conf", "--", \
  "render", \
    "/etc/mysql/my.cnf", "--", \
  "render", \
    "/etc/redis/redis.conf", "--", \
  "render", \
    "/etc/supervisor/supervisord.conf", "--", \
  "/entrypoint.sh" \
]

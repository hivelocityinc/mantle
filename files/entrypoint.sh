#!/bin/bash

set -eo pipefail

# Initializing mysql and create an user,database
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mkdir -p /var/lib/mysql

    mysql_install_db --datadir="/var/lib/mysql" --rpm

    /usr/bin/mysqld --user=root --skip-networking &
    pid="$!"

    mysql=( mysql --protocol=socket -uroot )

    for i in {30..0}; do
      if echo 'SELECT 1' | "${mysql[@]}" &> /dev/null; then
        break
      fi
      echo 'MySQL init process in progress...'
      sleep 1
    done

    if [ "$i" = 0 ]; then
      echo >&2 'MySQL init process failed.'
      exit 1
    fi

    "${mysql[@]}" <<-EOSQL
      UPDATE mysql.user SET Password=PASSWORD('${MYSQL_ROOT_PASSWORD}') WHERE User='root' ;
      DELETE FROM mysql.user WHERE User='' ;
      DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1') ;
      DROP DATABASE IF EXISTS test ;
      FLUSH PRIVILEGES ;
EOSQL
    echo "Finished mysql_secure_install"
    echo

    mysql+=( -p"${MYSQL_ROOT_PASSWORD}" )

    echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` ;" | "${mysql[@]}"
    echo "Created MySQL Database: $MYSQL_DATABASE"
    echo
    mysql+=( "$MYSQL_DATABASE" )

    "${mysql[@]}" <<-EOSQL
      CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' ;
      GRANT ALL ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%' ;
      FLUSH PRIVILEGES ;
EOSQL
    echo "Created MySQL User: $MYSQL_USER"
    echo

    if [ -d "/initdb.d/schema" ]; then
      for f in /initdb.d/schema/*; do
        case "$f" in
          *.sql) "${mysql[@]}" < "$f"; echo "Imported Schema: $f"; echo ;;
        esac
      done
    fi

    if [ -d "/initdb.d/seeds" ]; then
      for f in /initdb.d/seeds/*; do
        case "$f" in
          *.sql) "${mysql[@]}" < "$f"; echo "Imported Seeds: $f"; echo ;;
        esac
      done
    fi

  if ! kill -s TERM "$pid" || ! wait "$pid"; then
    echo >&2 'MySQL init process failed.'
    exit 1
  fi
fi

# Change owner/group in document root directory
chown -R nginx:nginx $NGINX_DOCUMENT_ROOT

# Run After Script
if [ -d "/after_run" ]; then
  for f in /after_run/*; do
    case "$f" in
      *.sh) sh "$f"; echo "Your scripts finished running: $f"; echo ;;
    esac
  done
fi

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf

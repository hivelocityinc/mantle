#!/bin/sh

set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mkdir -p /var/lib/mysql

    mysql_install_db --user=mysql --datadir="/var/lib/mysql" --rpm

    tempfile=`mktemp`
    if [ ! -f "$tempfile" ]; then
        return 1
    fi

    cat << EOF > $tempfile
  UPDATE mysql.user SET Password=PASSWORD('${MYSQL_ROOT_PASSWORD}') WHERE User='root';
  DELETE FROM mysql.user WHERE User='';
  DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
  DROP DATABASE IF EXISTS test;
  FLUSH PRIVILEGES;
  CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE} CHARACTER SET utf8 COLLATE utf8_general_ci;
  GRANT ALL ON ${MYSQL_DATABASE}.* to '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
EOF

    /usr/bin/mysqld --user=root --bootstrap --verbose=0 < $tempfile
    rm -rf $tempfile
fi

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf

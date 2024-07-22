#!/bin/sh

if [ ! -d /var/lib/mysql/data/$DB_TABLE_WORDPRESS ]; then
  mysql_install_db
  /usr/share/mariadb/mysql.server start
  mysql -e "\
    CREATE DATABASE IF NOT EXISTS ${DB_TABLE_WORDPRESS} DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci; \
    CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PWD}'; \
    GRANT ALL ON ${DB_TABLE_WORDPRESS}.* TO '${DB_USER}'@'%'; \
    ALTER USER 'root'@'localhost' IDENTIFIED BY ${DB_ADMIN_PWD}'; \
    FLUSH PRIVILEGES; \
    "
  mysqladmin --user=root shutdown
fi

mysqld_safe --datadir=/var/lib/mysql/data --user=root --port=3306
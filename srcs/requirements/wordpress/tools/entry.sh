# sed -i "s/.*listen = 127.0.0.1.*/listen = 9000/g" /etc/php82/php-fpm.d/www.conf
echo "env[DB_HOST] = \$DB_HOST" >> /etc/php82/php-fpm.d/www.conf
echo "env[DB_USER] = \$DB_USER" >> /etc/php82/php-fpm.d/www.conf
echo "env[DB_USER_PWD] = \$DB_USER_PWD" >> /etc/php82/php-fpm.d/www.conf
echo "env[DB_TABLE_WORDPRESS] = \$DB_TABLE_WORDPRESS" >> /etc/php82/php-fpm.d/www.conf

until mysql --host=$DB_HOST --user=$DB_USER --password=$DB_USER_PWD -e '\c'; do
  echo >&2 "mariadb is unavailable - sleeping"
  sleep 1
done
# ping -c 1 $DB_HOST
rm -f /var/www/html/wp-config.php
chown -R www-data:www-data /var/www/html
/wp-cli.phar config create --allow-root --dbname="$WP_DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_USER_PWD" --dbhost="$DB_HOST" --dbcharset=utf8mb4 --path=/var/www/html

wp core install --url="$WP_URL" --title="$WP_TITLE" --admin_user="$WP_ADMIN" --admin_password="$WP_ADMIN_PWD" --admin_email="$WP_ADMIN_EMAIL" --skip-email --path=/var/www/html --allow-root

wp user create "$WP_USER" "$WP_USER_EMAIL" --role=author --user_pass="$WP_USER_PWD" --allow-root --path=/var/www/html


if [ ! -f "/var/www/html/wp-config.php" ]; then
	exit 1
fi

php-fpm82 --nodaemonize

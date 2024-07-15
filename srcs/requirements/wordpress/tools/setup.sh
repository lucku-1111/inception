#!/bin/sh

if cat /etc/php81/php-fpm.d/www.conf | grep -q "user = nobody"; then
	echo "Configuring PHP-FPM..."
	sed -i 's/.*user = nobody.*/user = nginx/' /etc/php81/php-fpm.d/www.conf
	sed -i 's/.*group = nobody.*/group = nginx/' /etc/php81/php-fpm.d/www.conf
	sed -i 's/.*listen = 127.0.0.1.*/listen = 9000/g' /etc/php81/php-fpm.d/www.conf
else
	echo "PHP-FPM is already configured."
fi

for i in $(seq 60); do
	if ! mysqladmin -u $MYSQL_USER -p$MYSQL_USER_PASSWORD -h $MYSQL_HOST ping 2> /dev/null; then
		echo "Waiting for MySQL/MariaDB server to be ready... ($i sec)"
		sleep 1
	else
		break
	fi
done

sleep 10

# Check if WordPress is already installed
if [ ! -f "/var/www/html/wordpress/wp-config.php" ]; then
	# Create wp-config.php
	wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_USER_PASSWORD --dbhost=$MYSQL_HOST --allow-root --path=/var/www/html/wordpress <<PHP
	define( 'WP_CACHE', true );
PHP
	# Install WordPress
	wp core install --url=$WP_URL --title="$WP_TITLE" --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --path=/var/www/html/wordpress
	# Create a new user
	wp user create $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD --role=author --path=/var/www/html/wordpress
	echo "WordPress installation and configuration completed."
else
	echo "WordPress is already installed."
fi

# Start PHP-FPM
echo "Starting PHP-FPM..."
php-fpm81 -F
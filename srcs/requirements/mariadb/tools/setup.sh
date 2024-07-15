#!/bin/sh

# echo "root pw:  ${MYSQL_ROOT_PASSWORD}"
# echo "user:     ${MYSQL_USER}"
# echo "user pw:  ${MYSQL_USER_PASSWORD}"
# echo "database: ${MYSQL_DATABASE}"

if [ ! -f .setup_complete ]; then
	# Start MariaDB to initialize the database
	/usr/bin/mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null 2>&1

	# Start MariaDB in the background
	/usr/bin/mysqld_safe --datadir='/var/lib/mysql' > /dev/null 2>&1 &

	# Wait for MariaDB to start
	sleep 10

	# Set the root password
	mysql -u root -h localhost <<-EOSQL
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
		FLUSH PRIVILEGES;
	EOSQL

	# Create the database and user
	mysql -u root -p${MYSQL_ROOT_PASSWORD} -h localhost <<-EOSQL
		DELETE FROM mysql.user WHERE User='';
		DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
		DROP DATABASE test;
		DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
		CREATE DATABASE ${MYSQL_DATABASE};
		CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';
		GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
		CREATE USER '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';
		GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost';
		FLUSH PRIVILEGES;
	EOSQL

	# Stop the background MariaDB server
	mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

	touch .setup_complete && echo "MariaDB setup complete"
fi

# Start MariaDB in the foreground
echo "Starting MariaDB..."
exec /usr/bin/mysqld --user=mysql --console
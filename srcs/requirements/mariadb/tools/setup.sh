#!/bin/sh

echo "root pw:  ${MYSQL_ROOT_PASSWORD}"
echo "user:     ${MYSQL_USER}"
echo "user pw:  ${MYSQL_USER_PASSWORD}"
echo "database: ${MYSQL_DATABASE}"

# Start MariaDB to initialize the database
/usr/bin/mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null 2>&1

# Start MariaDB in the background
/usr/bin/mysqld_safe --datadir='/var/lib/mysql' &

# Wait for MariaDB to start
sleep 10

# Set the root password and create the database and user

mysql -u root -h localhost <<-EOSQL
	ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
	FLUSH PRIVILEGES;
EOSQL

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

# Start MariaDB in the foreground
exec /usr/bin/mysqld --user=mysql --console # --skip-networking=0 --bind-address=0.0.0.0

#!/bin/sh

if [ ! -f .setup_complete ]; then
	/usr/bin/mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null 2>&1

	/usr/bin/mysqld_safe --datadir='/var/lib/mysql' > /dev/null 2>&1 &

	sleep 10

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

	mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

	touch .setup_complete && echo "MariaDB setup complete"
fi

echo "Starting MariaDB..."
exec /usr/bin/mysqld --user=mysql
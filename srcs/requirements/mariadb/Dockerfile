FROM alpine:3.19

RUN apk --no-cache add mariadb mariadb-client mariadb-server-utils

RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld && \
	sed -i "s|^skip-networking|#skip-networking|" /etc/my.cnf.d/mariadb-server.cnf &&\
	sed -i "s|^#bind-address|bind-address|" /etc/my.cnf.d/mariadb-server.cnf

COPY ./tools/setup.sh /scripts/setup.sh

# COPY ./conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

RUN chmod +x /scripts/setup.sh

EXPOSE 3306

CMD [ "/scripts/setup.sh" ]
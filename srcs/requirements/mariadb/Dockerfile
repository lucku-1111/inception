FROM alpine:3.19

RUN apk --no-cache add dumb-init mariadb mariadb-client mariadb-server-utils

RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld && \
	sed -i "s|^skip-networking|#skip-networking|" /etc/my.cnf.d/mariadb-server.cnf &&\
	sed -i "s|^#bind-address|bind-address|" /etc/my.cnf.d/mariadb-server.cnf

COPY ./tools/setup.sh /scripts/setup.sh

RUN chmod +x /scripts/setup.sh

EXPOSE 3306

ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]

CMD [ "/scripts/setup.sh" ]
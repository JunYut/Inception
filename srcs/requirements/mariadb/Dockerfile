FROM alpine:3.21.3

RUN apk add --no-cache mariadb mariadb-client && \
	mysql_install_db --user=mysql --datadir=/var/lib/mysql

RUN chown -R mysql:mysql /var/lib/mysql

USER mysql

EXPOSE 3306

CMD ["mariadbd", "--datadir=/var/lib/mysql"]

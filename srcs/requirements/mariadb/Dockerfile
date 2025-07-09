FROM debian:bullseye

RUN apt update && \
    apt install -y mariadb-server mariadb-client && \
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

RUN mkdir -p /run/mysqld && \
    chown mysql:mysql /run/mysqld

RUN chown -R mysql:mysql /var/lib/mysql

USER mysql

EXPOSE 3306

CMD ["mariadbd", "--datadir=/var/lib/mysql"]

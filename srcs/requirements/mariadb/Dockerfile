FROM debian:bullseye

# install MariaDB
RUN apt update && \
    apt install -y mariadb-server mariadb-client gettext-base

# clean cache and remove package list
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# creates system database and data directory structure
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

# create runtime directory and set ownership
RUN mkdir -p /run/mysqld && \
    chown mysql:mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql

# create directory for SQL scripts and copy
RUN mkdir -p /docker-entrypoint-initdb.d/
COPY tools/setup.sql /docker-entrypoint-initdb.d/

# copy MariaDB configuration
COPY conf/mariadb.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# copy start up script
COPY tools/init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh

# runs with minimal permissions
USER mysql

EXPOSE 3306

CMD ["/usr/local/bin/init.sh"]

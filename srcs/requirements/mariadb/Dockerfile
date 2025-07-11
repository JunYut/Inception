FROM debian:bullseye

# install MariaDB
RUN apt update && \
    apt install -y mariadb-server mariadb-client

# clean cache and remove package list
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# creates system database and data directory structure
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

# create runtime directory and set ownership
RUN mkdir -p /run/mysqld && \
    chown mysql:mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql

# runs with minimal permissions
USER mysql

EXPOSE 3306

CMD ["mariadbd", "--datadir=/var/lib/mysql"]

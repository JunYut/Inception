#!/bin/bash

#* THIS SCRIPT SHOULD ONLY BE RUN USING DOCKERFILE

# Start MariaDB in background
mysqld_safe --user=mysql &

# Wait for MariaDB to start
sleep 5

# Execute setup script if it exists and hasn't been run
if [ -f '/docker-entrypoint-initdb.d/setup.sql' ] && [ ! -f "/var/lib/mysql/.setup_done" ]; then
    echo 'Running setup.sql...'
    mysql -u mysql < /docker-entrypoint-initdb.d/setup.sql
    touch /var/lib/mysql/.setup_done
fi

# Keep the script running
wait

#!/bin/bash

#* THIS SCRIPT SHOULD ONLY BE RUN USING DOCKERFILE

# Start MariaDB normally (without skip-grant-tables)
mysqld_safe --user=mysql &

# Wait for MariaDB to start
sleep 15

# Execute setup script if it exists and hasn't been run
if [ -f '/docker-entrypoint-initdb.d/setup.sql' ] && [ ! -f "/var/lib/mysql/.setup_done" ]; then
    echo 'Running setup.sql...'

    # Connect with no username/password (default for fresh MariaDB install)
    mysql < /docker-entrypoint-initdb.d/setup.sql

    if [ $? -eq 0 ]; then
        echo 'Setup completed successfully'
        touch /var/lib/mysql/.setup_done
    else
        echo 'Setup failed'
        exit 1
    fi
fi

# Keep the container running
wait

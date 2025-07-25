#!/bin/bash

#* THIS SCRIPT SHOULD ONLY BE RUN USING DOCKERFILE

# Start MariaDB normally (without skip-grant-tables)
mysqld_safe --user=mysql &

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to start..."
until mysqladmin ping -h127.0.0.1 >/dev/null 2>&1; do
    echo "MariaDB is unavailable - sleeping"
    sleep 2
done

echo "MariaDB is ready!"

# Execute setup script if it exists and hasn't been run
if [ -f '/docker-entrypoint-initdb.d/setup.sql' ] && [ ! -f "/var/lib/mysql/.setup_done" ]; then
    echo 'Running setup.sql...'

    envsubst < /docker-entrypoint-initdb.d/setup.sql > /tmp/setup.sql

    # Connect with no username/password (default for fresh MariaDB install)
    mysql < /tmp/setup.sql

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

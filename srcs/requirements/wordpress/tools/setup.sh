#!/bin/bash
# file: srcs/requirements/wordpress/tools/setup.sh

# wait for the database to be ready
echo "Waiting for the database to be ready..."
while ! nc -z mariadb 3306; do
    echo "Waiting for database connection..."
    sleep 1
done
echo "Database is ready!"

# wait for Redis to be ready
echo "Waiting for Redis to be ready..."
while ! nc -z redis 6379; do
  sleep 1
done
echo "Redis is ready!"

# setup WordPress
cd /var/www/wordpress

# Download WordPress if not already present
if [ ! -f "wp-config-sample.php" ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root
    echo "WordPress downloaded!"
fi

# Create wp-config.php if it doesn't exist
if [ ! -f "wp-config.php" ]; then
    echo "wp-config.php not found, creating it..."

    # create basic wp-config.php
    wp config create \
        --dbname=$WP_DB_NAME \
        --dbuser=$WP_DB_USER \
        --dbpass=$WP_DB_PASSWORD \
        --dbhost=$WP_DB_HOST \
        --allow-root

    # set table prefix
    wp config set table_prefix $WP_TABLE_PREFIX --allow-root

    # Redis configuration
    wp config set WP_CACHE true --raw --allow-root
    wp config set WP_REDIS_HOST $WP_REDIS_HOST --allow-root
    wp config set WP_REDIS_PORT $WP_REDIS_PORT --raw --allow-root
    wp config set WP_REDIS_DATABASE $WP_REDIS_DATABASE --raw --allow-root
    wp config set WP_REDIS_TIMEOUT $WP_REDIS_TIMEOUT --raw --allow-root

    echo "wp-config.php created!"
else
    echo "WordPress is already installed."
fi

# Install WordPress core if not already installed
if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    wp core install \
        --url=$WP_SITE_URL \
        --title=$WP_SITE_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --skip-email \
        --allow-root
    echo "WordPress installed!"
else
    echo "WordPress is already installed."
fi

# Plugin management
echo "Managing plugins..."

# Install Redis Object Cache plugin
if ! wp plugin is-installed redis-cache --allow-root; then
    echo "Installing Redis Object Cache plugin..."
    wp plugin install redis-cache --activate --allow-root
    echo "Redis Object Cache plugin installed!"
else
    echo "Redis Object Cache plugin is already installed."
fi

# Activate the plugin if not already activated
if ! wp plugin is-active redis-cache --allow-root; then
    echo "Activating Redis Object Cache plugin..."
    wp plugin activate redis-cache --allow-root
    echo "Redis Object Cache plugin activated!"
else
    echo "Redis Object Cache plugin is already active."
fi

wp redis enable --allow-root

echo "WordPress setup complete!"

echo "Starting PHP-FPM..."
exec "$@"

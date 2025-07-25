-- Create WordPress database
CREATE DATABASE IF NOT EXISTS `${WP_DB_NAME}`;

-- Create WordPress user with secure password
CREATE USER IF NOT EXISTS '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASSWORD}';

-- Grant privileges to WordPress user
GRANT ALL PRIVILEGES ON `${WP_DB_NAME}`.* TO '${WP_DB_USER}'@'%';

-- Reload privilege tables
FLUSH PRIVILEGES;

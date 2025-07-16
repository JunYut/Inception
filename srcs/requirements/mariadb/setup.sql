-- Create WordPress database
CREATE DATABASE IF NOT EXISTS wordpress_db;

-- Create WordPress user with secure password
CREATE USER IF NOT EXISTS 'wp_user'@'%' IDENTIFIED BY 'pass';

-- Grant privileges to WordPress user
GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wp_user'@'%';

-- Reload privilege tables
FLUSH PRIVILEGES;

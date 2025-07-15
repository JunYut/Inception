CREATE DATABASE wordpress_db;

CREATE USER 'wp_user'@'%' IDENTIFIED BY 'securepassword';
GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wp_user'@'%';

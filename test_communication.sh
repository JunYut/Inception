#!/bin/bash

echo "=== WordPress ↔ MariaDB Communication Test ==="
echo

# Test 1: Container status
echo "1. Container Status:"
docker compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
echo

# Test 2: Network connectivity
echo "2. Network Test:"
echo "WordPress container IP: $(docker inspect srcs-wordpress-1 --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')"
echo "MariaDB container IP: $(docker inspect srcs-mariadb-1 --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')"
echo

# Test 3: MariaDB process check
echo "3. MariaDB Process Check:"
docker exec srcs-mariadb-1 pgrep -f mysql >/dev/null && echo "✅ MariaDB process is running" || echo "❌ MariaDB process not found"
echo

# Test 4: Port connectivity (will fail because 'nc' is not found)
echo "4. Port Connectivity Test:"
docker exec srcs-wordpress-1 nc -z mariadb 3306 >/dev/null 2>&1 && echo "✅ Port 3306 is reachable" || echo "❌ Port 3306 is not reachable"
echo

# Test 5: WordPress config check
echo "5. WordPress Configuration:"
docker exec srcs-wordpress-1 grep -E "DB_(HOST|USER|PASSWORD|NAME)" /var/www/wordpress/wp-config.php 2>/dev/null || echo "wp-config.php not found in expected location"
echo

# Test 6: PHP MySQL extension
echo "6. PHP MySQL Extension:"
docker exec srcs-wordpress-1 php -m | grep -E "(pdo_mysql|mysql)" || echo "MySQL extensions not found"
echo

# Test 7: Database connection attempt
echo "7. Database Connection Test:"
docker exec srcs-wordpress-1 php -r "
try {
    new PDO('mysql:host=mariadb;dbname=wordpress_db', 'wp_user', 'pass');
    echo '✅ Connection successful';
} catch (Exception \$e) {
    echo '❌ Connection failed: ' . \$e->getMessage();
}
" 2>/dev/null || echo "PHP test failed"

echo
echo "=== Test Complete ==="

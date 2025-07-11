# docker
## Build image
```bash
docker build -t <image-name> <directory>
```

## Run container
```bash
docker run -d -p <host-port>:<container-port> <image-name>
```

## Run container with volume
```bash
docker run -d -p <host-port>:<container-port> -v <host-path>:<container-path>:<permission> <image-name>
```

## Start container with a terminal and removes container when it exits
```bash
docker run -it --rm <image-name>
```

## Opens interactive shell in a running container
```bash
docker exec -it <container_name_or_id> sh
```

## Stop container
```bash
docker stop <container_name_or_id>
```

# docker compose
## Run containers
```bash
docker compose up
```

## Build and run containers
```bash
docker compose up --build
```

# WordPress
## File Structure
```
/var/www/wordpress/
├── index.php
├── license.txt
├── readme.html
├── wp-activate.php
├── wp-admin/
├── wp-blog-header.php
├── wp-comments-post.php
├── wp-config-sample.php
├── wp-content/
├── wp-cron.php
├── wp-includes/
├── wp-links-opml.php
├── wp-load.php
├── wp-login.php
├── wp-mail.php
├── wp-settings.php
├── wp-signup.php
├── wp-trackback.php
└── xmlrpc.php
```

### Key WordPress Files:
- **index.php** - Main entry point for WordPress
- **wp-config.php** - WordPress configuration (created from wp-config-sample.php)
- **wp-admin/** - WordPress admin dashboard files
- **wp-content/** - Themes, plugins, uploads
- **wp-includes/** - Core WordPress functions and libraries
- **wp-login.php** - Login page

## WordPress Routing Architecture

**Yes! The client primarily interacts with `index.php`, which handles all internal routing.**

### How WordPress Routing Works:

1. **All requests** (except static files) → `index.php`
2. **index.php** loads WordPress core and determines what content to show
3. **WordPress router** parses the URL and matches it to:
   - Posts/Pages
   - Categories/Tags
   - Custom post types
   - Admin pages
   - API endpoints

### Example Request Flow:
```
Client Request: GET /about
    ↓
Nginx: try_files $uri $uri/ /index.php?$args
    ↓ (no physical /about file exists)
Falls back to: /index.php
    ↓
WordPress Router: Parses "/about"
    ↓
Database Query: Find page with slug "about"
    ↓
Template Engine: Load appropriate theme template
    ↓
Response: Rendered "About" page HTML
```

### Why This Design?
- **Single Entry Point**: All logic centralized in one place
- **Clean URLs**: `/blog/my-post` instead of `/index.php?p=123`
- **Security**: All requests go through WordPress security checks
- **Flexibility**: Easy to add custom routing rules

# MariaDB
## Purpose
MariaDB serves as the database backend for WordPress, storing all content, user data, and configuration.

## Database Structure
```
/var/lib/mysql/
├── mysql/              # System database (users, privileges)
├── information_schema/ # Database metadata
├── performance_schema/ # Performance monitoring
├── wordpress/          # WordPress database
├── ib_logfile0        # InnoDB transaction logs
├── ib_logfile1
├── ibdata1            # InnoDB system tablespace
└── mysql.sock         # Unix socket for connections
```

## Key MariaDB Components:
- **mysql database** - User accounts and permissions
- **wordpress database** - All WordPress content and settings
- **InnoDB storage engine** - ACID compliance and crash recovery
- **Transaction logs** - Data integrity and recovery

## Container Configuration:
- **Port**: 3306 (MySQL/MariaDB standard)
- **User**: `mysql` (non-root for security)
- **Data Directory**: `/var/lib/mysql`
- **Socket**: `/run/mysqld/mysqld.sock`

## Database Initialization Process:
1. **mysql_install_db** - Creates system databases
2. **Set ownership** - All files owned by `mysql` user
3. **Runtime directory** - Create `/run/mysqld` for PID and socket
4. **Security** - Run as `mysql` user, not root

# Nginx
## Purpose
Nginx acts as a reverse proxy and web server, handling HTTP requests and serving static files while forwarding PHP requests to WordPress.

## Nginx Configuration Structure
```
/etc/nginx/
├── nginx.conf          # Main configuration file
├── sites-available/    # Available site configurations
├── sites-enabled/      # Active site configurations
└── conf.d/            # Additional configuration files
```

## Request Flow Architecture:
```
Client Browser
    ↓ HTTP Request
Nginx (Port 8080)
    ↓ Static files → Serve directly
    ↓ PHP files → Forward to WordPress container
WordPress PHP-FPM (Port 9000)
    ↓ Database queries
MariaDB (Port 3306)
```

## Key Nginx Directives:
- **listen 8080** - Listen on port 8080 (non-privileged port)
- **root /var/www/wordpress** - Document root directory
- **try_files** - WordPress URL routing and fallback
- **fastcgi_pass** - Forward PHP to WordPress container
- **index index.php** - Default file to serve

## Security Features:
- **Non-root user** - Runs as `www-data` for security
- **Static file serving** - Direct file serving for performance
- **PHP isolation** - PHP processing isolated in separate container
- **Access control** - Deny access to sensitive files (.htaccess, etc.)

## Performance Optimizations:
- **Static file caching** - Browser caching for CSS, JS, images
- **FastCGI** - Efficient PHP communication
- **Keep-alive connections** - Persistent connections for better performance

# Architecture Overview
## Multi-Container Setup
This project uses a **three-tier architecture** with separate containers for each service:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     Nginx       │    │   WordPress     │    │    MariaDB      │
│  (Web Server)   │◄──►│   (PHP-FPM)     │◄──►│   (Database)    │
│   Port: 8080    │    │   Port: 9000    │    │   Port: 3306    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Service Communication:
1. **Client** → **Nginx** (HTTP requests on port 8080)
2. **Nginx** → **WordPress** (FastCGI on port 9000)
3. **WordPress** → **MariaDB** (MySQL protocol on port 3306)

## Data Flow Example:
```
1. User visits: http://localhost:8080/blog
2. Nginx receives request
3. Nginx checks: /var/www/wordpress/blog (not found)
4. Nginx forwards to: WordPress container via FastCGI
5. WordPress queries: MariaDB for blog posts
6. MariaDB returns: Blog post data
7. WordPress renders: HTML page
8. Nginx returns: Rendered page to user
```

## Security Model:
- **Nginx**: Runs as `www-data` (web server user)
- **WordPress**: Runs as `www-data` (same as Nginx for file sharing)
- **MariaDB**: Runs as `mysql` (isolated database user)
- **Network**: Internal Docker network (services can't be accessed directly)
- **Ports**: Only Nginx port 8080 exposed to host

## Volume Management:
- **WordPress files**: Shared between Nginx and WordPress containers
- **Database data**: Persistent MariaDB data directory
- **Logs**: Container logs accessible via `docker compose logs`

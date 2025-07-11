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

# Docker Inception Project Makefile
# This Makefile manages the WordPress, Nginx, and MariaDB containers

# Variables
COMPOSE_FILE = srcs/docker-compose.yml
COMPOSE_CMD = docker compose -f $(COMPOSE_FILE)

# Default target
all: build run

# Build all Docker images
build:
	@echo "Creating volumes..."
	mkdir -p ~/data/wordpress ~/data/mariadb
	@echo "Building Docker images..."
	$(COMPOSE_CMD) build

# Start all services
run:
	@echo "Starting all services..."
	$(COMPOSE_CMD) up -d

# Stop all services (keeps containers)
stop:
	@echo "Stopping all services..."
	$(COMPOSE_CMD) stop

# Stop and remove all containers, networks, and volumes
down:
	@echo "Stopping and removing all containers..."
	$(COMPOSE_CMD) down -v

# Restart all services
restart: stop run

# Clean everything (containers, images, volumes, networks)
clean: down
	@echo "Cleaning up Docker resources..."
	docker system prune -f
	docker volume prune -f
	docker network prune -f

# Remove all project images
clean-images:
	@echo "Removing project images..."
	docker rmi -f srcs-nginx srcs-wordpress srcs-mariadb 2>/dev/null || true

# Full clean (everything including images)
fclean: clean clean-images

# Rebuild everything from scratch
re: down all

# Show container status
status:
	@echo "Container status:"
	$(COMPOSE_CMD) ps

# Show logs for all services
logs:
	$(COMPOSE_CMD) logs -f

# Show logs for specific service (usage: make logs-nginx, make logs-wordpress, make logs-mariadb)
logs-nginx:
	$(COMPOSE_CMD) logs -f nginx

logs-wordpress:
	$(COMPOSE_CMD) logs -f wordpress

logs-mariadb:
	$(COMPOSE_CMD) logs -f mariadb

# Test network connectivity
test-network:
	@echo "Testing network connectivity..."
	@./test_communication.sh

# Monitor containers
monitor:
	@echo "Monitoring containers..."
	@./monitor_network.sh

# Enter container shells
shell-nginx:
	docker exec -it nginx /bin/bash

shell-wordpress:
	docker exec -it wordpress /bin/bash

shell-mariadb:
	docker exec -it mariadb /bin/bash

# Database operations
db-connect:
	docker exec -it mariadb mysql -u wp_user -p'pass' wordpress_db

db-root:
	docker exec -it mariadb mysql -u root -p

# Development helpers
dev-wordpress:
	@echo "WordPress development mode..."
	docker exec -it wordpress tail -f /var/log/php7.4-fpm.log

dev-nginx:
	@echo "Nginx development mode..."
	docker exec -it nginx tail -f /var/log/nginx/access.log

# Help target
help:
	@echo "Available targets:"
	@echo "  build         - Build all Docker images"
	@echo "  run           - Start all services"
	@echo "  stop          - Stop all services"
	@echo "  down          - Stop and remove containers"
	@echo "  restart       - Restart all services"
	@echo "  clean         - Clean Docker resources"
	@echo "  fclean        - Full clean including images"
	@echo "  re            - Rebuild everything from scratch"
	@echo "  status        - Show container status"
	@echo "  logs          - Show logs for all services"
	@echo "  logs-SERVICE  - Show logs for specific service"
	@echo "  test-network  - Test network connectivity"
	@echo "  monitor       - Monitor containers"
	@echo "  shell-SERVICE - Enter container shell"
	@echo "  db-connect    - Connect to database as wp_user"
	@echo "  db-root       - Connect to database as root"
	@echo "  dev-SERVICE   - Development mode for service"
	@echo "  help          - Show this help message"

# Phony targets (not files)
.PHONY: all build run stop down restart clean clean-images fclean re status logs logs-nginx logs-wordpress logs-mariadb test-network monitor shell-nginx shell-wordpress shell-mariadb db-connect db-root dev-wordpress dev-nginx help

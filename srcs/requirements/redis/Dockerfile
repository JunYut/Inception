FROM debian:bullseye

# Install Redis
RUN apt-get update && \
    apt-get install -y redis-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Expose Redis port
EXPOSE 6379

# Switch to redis user for security
USER redis

CMD ["redis-server"]

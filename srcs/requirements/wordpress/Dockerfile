FROM alpine:3.21.3

# Install PHP, PHP-FPM, and required extensions
RUN apk add --no-cache \
    php82 php82-fpm php82-mysqli php82-json php82-session php82-gd php82-curl php82-xml \
    php82-mbstring php82-zip php82-dom php82-opcache curl unzip

# Create a user and group for running WordPress
RUN addgroup -S www && adduser -S www -G www

# Prepare the web root && log directory
RUN mkdir -p /var/www && chown www:www /var/www && \
	mkdir -p /var/log/php82 && chown www:www /var/log/php82

# Download and extract WordPress
USER www
RUN curl -o /tmp/wordpress.zip https://wordpress.org/latest.zip && \
    unzip /tmp/wordpress.zip -d /var/www/ && \
    rm /tmp/wordpress.zip

USER root

# Set permissions
RUN chown -R www:www /var/www/wordpress

# Configure PHP-FPM to listen on all interfaces (for Nginx to connect)
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php82/php-fpm.d/www.conf && \
    sed -i 's|^user = .*|user = www|' /etc/php82/php-fpm.d/www.conf && \
    sed -i 's|^group = .*|group = www|' /etc/php82/php-fpm.d/www.conf

USER www

EXPOSE 9000

CMD ["/usr/sbin/php-fpm82", "-F"]

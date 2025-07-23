FROM debian:bullseye

# install Nginx and OpenSSL
RUN apt update && \
    apt install -y nginx openssl

# runtime directory for process ID files and temporary files
RUN mkdir -p /run/nginx

# create wordpress directory
RUN mkdir -p /var/www/wordpress

# create SSL directory and generate self-signed certificate
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# copy config from host
COPY conf/nginx.conf /etc/nginx/nginx.conf

# set ownership for runtime directory
RUN chown -R www-data:www-data /run/nginx /var/lib/nginx /var/log/nginx /etc/nginx/ssl

# switch to non-root user for security
USER www-data

EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]

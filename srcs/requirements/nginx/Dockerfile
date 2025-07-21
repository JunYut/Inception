FROM debian:bullseye

# install Nginx
RUN apt update && \
    apt install -y nginx

# runtime directory for process ID files and temporary files
RUN mkdir -p /run/nginx

# create wordpress directory
RUN mkdir -p /var/www/wordpress

# copy config from host
COPY conf/nginx.conf /etc/nginx/nginx.conf

# set ownership for runtime directory
RUN chown -R www-data:www-data /run/nginx /var/lib/nginx /var/log/nginx

# switch to non-root user for security
USER www-data

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]

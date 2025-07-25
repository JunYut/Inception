FROM debian:bullseye

# install PHP dependencies
RUN apt update && \
    apt install -y php-fpm php-mysql php-curl php-xml php-mbstring php-zip \
    php-gd unzip wget netcat

# clean cache and remove package list
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# runtime directory for process ID files and socket files
RUN mkdir -p /run/php/ /var/log/

# create wordpress directory
RUN mkdir -p /var/www/wordpress/ /var/www/.wp-cli/cache/ && \
    touch /var/www/wordpress/tmp

# install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# copy config and setup script from host
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

# only allows php-fpm to access wordpress/ (php-fpm runs as www-data user)
RUN chown -R www-data:www-data /run/php/ /var/log/ /var/www/wordpress/ /var/www/.wp-cli/cache/ && \
    chmod -R 755 /var/www/

# switch to non-root user for security
USER www-data

EXPOSE 9000

ENTRYPOINT [ "/usr/local/bin/setup.sh" ]
CMD [ "php-fpm7.4", "-F" ]

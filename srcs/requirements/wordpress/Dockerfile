FROM debian:bullseye

# install PHP dependencies
RUN apt update && \
    apt install -y php-fpm php-mysql php-curl php-xml php-mbstring php-zip \
    php-gd unzip wget

# clean cache and remove package list
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# runtime directory for process ID files and socket files
RUN mkdir -p /run/php

# install wordpress
RUN mkdir -p /var/www && \
    cd /var/www && \
    wget https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    rm latest.zip

# only allows php-fpm to access wordpress/ (php-fpm runs as www-data user)
RUN chown -R www-data:www-data wordpress && \
    chmod -R 755 wordpress && \
    chown -R www-data:www-data /run/php

# switch to non-root user for security
USER www-data

EXPOSE 9000

CMD [ "php-fpm7.4", "-F" ]

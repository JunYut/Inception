FROM debian:bullseye

RUN apt update && \
    apt install -y php-fpm php-mysql php-curl php-xml php-mbstring php-zip \
    php-gd unzip wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php

RUN mkdir -p /var/www && \
    cd /var/www && \
    wget https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    rm latest.zip && \
    chown -R www-data:www-data wordpress && \
    chmod -R 755 wordpress

EXPOSE 9000

CMD [ "php-fpm7.4", "-F" ]

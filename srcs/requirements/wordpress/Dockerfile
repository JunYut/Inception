FROM debian:bullseye

RUN apt update && \
    apt install -y php-fpm php-mysql php-curl php-xml php-mbstring php-zip \
    php-gd unzip wget

RUN which php-fpm || which php-fpm7.4

RUN mkdir -p /var/www && \
    cd /var/www && \
    wget https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    mv wordpress mysite && \
    chown -R www-data:www-data mysite && \
    chmod -R 755 mysite

EXPOSE 9000

CMD [ "php-fpm7.4", "-F" ]

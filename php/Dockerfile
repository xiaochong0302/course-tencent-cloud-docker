FROM mileschou/phalcon:7.3-fpm

RUN apt-get update \
    && apt-get install -y cron git wget zip unzip --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/*

RUN docker-php-ext-install mbstring pdo_mysql \
    && pecl install redis-4.1.1 \
    && docker-php-ext-enable redis

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer config -g repo.packagist composer https://mirrors.cloud.tencent.com/composer

RUN usermod -u 1000 www-data

VOLUME ["/var/log/php-fpm", "/var/www/html"]

EXPOSE 9000
FROM php:7.3-fpm

ARG PHALCON_VERSION=3.4.5
ARG PHALCON_EXT_PATH=php7/64bits

COPY ./sources.list /opt

RUN cat /opt/sources.list > /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y git wget zip unzip --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/*

RUN curl -LO https://course-1255691183.cos.ap-guangzhou.myqcloud.com/cphalcon/v${PHALCON_VERSION}.tar.gz \
    && tar xzf ${PWD}/v${PHALCON_VERSION}.tar.gz \
    && docker-php-ext-install -j $(getconf _NPROCESSORS_ONLN) ${PWD}/cphalcon-${PHALCON_VERSION}/build/${PHALCON_EXT_PATH} \
    && rm -r ${PWD}/v${PHALCON_VERSION}.tar.gz ${PWD}/cphalcon-${PHALCON_VERSION}

RUN docker-php-ext-install mbstring pdo_mysql \
    && pecl install redis-4.1.1 \
    && docker-php-ext-enable redis

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer config -g repo.packagist composer https://packagist.phpcomposer.com

RUN usermod -u 1000 www-data

VOLUME ["/var/log/php-fpm", "/var/www/html"]

EXPOSE 9000
FROM mileschou/phalcon:7.3-fpm

ARG SOURCES_LIST=/etc/apt/sources.list

RUN apt-get update \
    && echo "" > ${SOURCES_LIST} \
    && echo "deb http://mirrors.cloud.tencent.com/debian buster main contrib non-free" >> ${SOURCES_LIST} \
    && echo "deb http://mirrors.cloud.tencent.com/debian buster-updates main contrib non-free" >> ${SOURCES_LIST} \
    && apt-get -y install -qq nano zip unzip --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \

RUN docker-php-ext-install mbstring pdo_mysql \
    && pecl install redis-4.1.1 \
    && docker-php-ext-enable redis

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer config -g repo.packagist composer https://mirrors.cloud.tencent.com/composer

RUN touch /var/log/cron.log

RUN usermod -u 1000 www-data

VOLUME ["/var/log/php-fpm", "/var/www/html", "/etc/cron.d"]

EXPOSE 9000

CMD cron && tail -f /var/log/cron.log
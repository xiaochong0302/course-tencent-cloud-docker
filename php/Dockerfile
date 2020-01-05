FROM mileschou/phalcon:7.3-fpm

ARG TZ=Asia/Shanghai
ARG SOURCES_LIST=/etc/apt/sources.list

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone

RUN echo "" > ${SOURCES_LIST} \
    && echo "deb http://mirrors.cloud.tencent.com/debian buster main contrib non-free" >> ${SOURCES_LIST} \
    && echo "deb http://mirrors.cloud.tencent.com/debian buster-updates main contrib non-free" >> ${SOURCES_LIST} \
    && apt-get update \
    && apt-get install -y --no-install-recommends supervisor cron nano zip unzip \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pcntl mbstring pdo_mysql \
    && pecl install redis-4.3.0 igbinary \
    && docker-php-ext-enable redis igbinary

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer config -g repo.packagist composer https://mirrors.cloud.tencent.com/composer

COPY ./cron.d/course /etc/cron.d/course

RUN chmod 644 /etc/cron.d/course

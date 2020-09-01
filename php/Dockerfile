FROM php:7.3-fpm-buster

LABEL maintainer="xiaochong0302@qq.com"

ARG PHALCON_VERSION=3.4.5.1
ARG PHALCON_EXT_PATH=php7/64bits

ARG TZ=Asia/Shanghai
ARG SOURCES_LIST=/etc/apt/sources.list

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone

RUN set -xe && \
    curl -L https://gitee.com/koogua/cphalcon/repository/archive/v${PHALCON_VERSION}?format=tar.gz -o ${PHALCON_VERSION}.tar.gz && \
    tar xzf ${PWD}/v${PHALCON_VERSION}.tar.gz && \
    docker-php-ext-install -j $(getconf _NPROCESSORS_ONLN) ${PWD}/cphalcon-${PHALCON_VERSION}/build/${PHALCON_EXT_PATH} && \
    rm -r \
        ${PWD}/v${PHALCON_VERSION}.tar.gz \
        ${PWD}/cphalcon-${PHALCON_VERSION}

COPY docker-phalcon-* /usr/local/bin/

RUN echo "" > ${SOURCES_LIST} \
    && echo "deb http://mirrors.cloud.tencent.com/debian buster main contrib non-free" >> ${SOURCES_LIST} \
    && echo "deb http://mirrors.cloud.tencent.com/debian buster-updates main contrib non-free" >> ${SOURCES_LIST} \
    && apt-get update \
    && apt-get install -y --no-install-recommends supervisor cron nano zip unzip libpng-dev \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pcntl mbstring pdo_mysql gd \
    && pecl install igbinary redis \
    && docker-php-ext-enable igbinary redis

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer config -g repo.packagist composer https://mirrors.cloud.tencent.com/composer

COPY ./cron.d/course /etc/cron.d/course

RUN chmod 644 /etc/cron.d/course
